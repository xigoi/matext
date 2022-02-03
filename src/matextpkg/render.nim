import ./lookup
import ./textrect
import honeycomb
import std/sequtils
import std/strutils
import std/sugar
import std/tables

func bigDelimiter(delimiter: string, height, baseline: Natural): TextRect =
  const delimiterParts = {
    "(": ("╭", "│", "╰"),
    ")": ("╮", "│", "╯"),
    "[": ("┌", "│", "└"),
    "]": ("┐", "│", "┘"),
  }.toTable
  case delimiter
  of "{":
    discard
  else:
    let (top, mid, bottom) = delimiterParts[delimiter]
    result.rows = newSeq[string](height)
    result.rows[0] = top
    for i in 1 ..< height - 1:
      result.rows[i] = mid
    result.rows[^1] = bottom
    result.width = 1
  result.baseline = baseline

let ws = whitespace.many
var atom = fwdcl[TextRect]()
let expr = atom.many.map(atoms => atoms.join)
let oneChar = alphanumeric.map(ch => ($ch).toTextRect(0, trfAlnum))
let binaryOp = binaryOperators.map(it => s(it[0]).result(it[1])).foldr(a | b).map(s => s.toTextRect(flag = trfOperator))
let delimiter = delimiters.map(it => s(it[0]).result(it[1])).foldr(a | b).map(s => s.toTextRect)
let relation = relations.map(it => s(it[0]).result(it[1])).foldr(a | b).map(s => s.toTextRect(flag = trfOperator))
let textOp = textOperators.map(it => s(it[0]).result(it[1])).foldr(a | b).map(s => s.toTextRect(flag = trfWord))
let frac = s"\frac" >> (atom & atom).map(fraction => (
  let numerator = fraction[0]
  let denominator = fraction[1]
  let width = max(numerator.width, denominator.width)
  var fractionLine = "─".repeat(width)
  var flag = trfFraction
  if (numerator.flag == trfFraction and numerator.width == width) or
     (denominator.flag == trfFraction and denominator.width == width):
    fractionLine = "╶" & fractionLine & "╴"
    flag = trfNone
  stack(numerator, fractionLine.toTextRect, denominator, numerator.height, saCenter).withFlag(flag)
))
let sqrt = s"\sqrt" >> atom.map(arg => (
  let overbar = "_".repeat(arg.width).toTextRect
  let symbol =
    if arg.height == 1:
      "√".toTextRect
    else:
      join(
        countdown(arg.height div 2, 1).toSeq.mapIt("╲".toTextRect(arg.baseline - arg.height + it)) &
        countup(1, arg.height).toSeq.mapIt("╱".toTextRect(arg.baseline - arg.height + it))
      )
  join(symbol, stack(overbar, arg, arg.baseline + 1, saLeft))
))
let leftright = (s"\left" >> delimiter & expr & (s"\right" >> delimiter)).map(things => (
  let inside = things[1]
  var left = things[0]
  var right = things[2]
  if inside.height > 1:
    left = left.rows[0].bigDelimiter(inside.height, inside.baseline)
    right = right.rows[0].bigDelimiter(inside.height, inside.baseline)
  join(left, inside, right)
))
let bracedExpr = c('{') >> expr << c('}')
let atom1 = (bracedExpr | leftright | oneChar | binaryOp | delimiter | relation | textOp | frac | sqrt) << ws
let superscript = (c('^') >> atom1).map(sup => sup.withFlag(trfSup))
let subscript = (c('_') >> atom1).map(sub => sub.withFlag(trfSub))
atom.become (atom1 & ((superscript & subscript) | (subscript & superscript) | superscript.asSeq | subscript.asSeq).optional).map(operands => (
  let base = operands[0]
  result = case operands.len
  of 1:
    base
  of 2:
    var script = operands[1]
    script.baseline =
      if script.flag == trfSup:
        base.baseline + script.height
      else:
        base.baseline - base.height
    base & script
  of 3:
    let (sup, sub) =
      if operands[1].flag == trfSup:
        (operands[1], operands[2])
      else:
        (operands[2], operands[1])
    base & stack(sup.extendDown(base.height), sub, base.baseline + sup.height, saLeft)
  else:
    TextRect()
  if base.flag in {trfAlnum, trfWord}:
    result.flag = base.flag
))
let completeExpr = expr << eof

proc render*(latex: string): string =
  let parsed = completeExpr.parse(latex)
  if parsed.kind == success:
    $parsed.value
  else:
    raise newException(ValueError, "Can't parse expression")
