import ./lookup
import ./textrect
import honeycomb
import std/sequtils
import std/strutils
import std/sugar
import std/tables
import std/unicode

func bigDelimiter(delimiter: string, height, baseline: Natural): TextRect =
  const delimiterParts = {
    "(": ("⎛", "⎜", "⎝"),
    ")": ("⎞", "⎟", "⎠"),
    "[": ("⎡", "⎢", "⎣"),
    "]": ("⎤", "⎥", "⎦"),
    "∣": ("│", "│", "│"),
    "∥": ("║", "║", "║"),
    "⌈": ("⎡", "⎢", "⎢"),
    "⌉": ("⎤", "⎥", "⎥"),
    "⌊": ("⎢", "⎢", "⎣"),
    "⌋": ("⎥", "⎥", "⎦"),
  }.toTable
  result.rows = newSeq[string](height)
  result.width = 1
  result.baseline = baseline
  case delimiter
  of "{":
    if height == 2:
      result.rows[0] = "⎰"
      result.rows[1] = "⎱"
    else:
      result.rows[0] = "⎧"
      for i in 1 ..< height - 1:
        result.rows[i] = "⎪"
      result.rows[height div 2] = "⎨"
      result.rows[^1] = "⎩"
  of "}":
    if height == 2:
      result.rows[0] = "⎱"
      result.rows[1] = "⎰"
    else:
      result.rows[0] = "⎫"
      for i in 1 ..< height - 1:
        result.rows[i] = "⎪"
      result.rows[height div 2] = "⎬"
      result.rows[^1] = "⎭"
  of "⟨":
    result.width = (height + 1) div 2
    let widthDec = result.width - 1
    if height mod 2 == 1:
      result.rows[height div 2] = "⟨" & " ".repeat(height div 2)
    for i in 0..<height div 2:
      result.rows[i] = " ".repeat(widthDec - i) & "╱" & " ".repeat(i)
      result.rows[height - 1 - i] = " ".repeat(widthDec - i) & "╲" & " ".repeat(i)
  of "⟩":
    result.width = (height + 1) div 2
    let widthDec = result.width - 1
    if height mod 2 == 1:
      result.rows[height div 2] = " ".repeat(height div 2) & "⟩"
    for i in 0..<height div 2:
      result.rows[i] = " ".repeat(i) & "╲" & " ".repeat(widthDec - i)
      result.rows[height - 1 - i] = " ".repeat(i) & "╱" & " ".repeat(widthDec - i)
  else:
    let (top, mid, bottom) = delimiterParts[delimiter]
    result.rows[0] = top
    for i in 1 ..< height - 1:
      result.rows[i] = mid
    result.rows[^1] = bottom

func lookupTableParser(table: openArray[(string, string)], flag = trfNone): Parser[TextRect] =
  table.map(it => s(it[0]).result(it[1])).foldr(a | b).map(s => s.toTextRect(flag = flag))

let ws = whitespace.many
var atom = fwdcl[TextRect]()
let expr = atom.many.map(atoms => atoms.join)

let digit = c('0'..'9').map(ch => ($ch).toTextRect(0, trfAlnum))
let latinLetter = c('A'..'Z').map(ch => ($(ch.int + 119795).Rune).toTextRect(0, trfAlnum)) |
                  c('a'..'z').map(ch => ($(ch.int + 119789).Rune).toTextRect(0, trfAlnum))

let otherLetter = letters.lookupTableParser
let binaryOp = binaryOperators.lookupTableParser(trfOperator)
let delimiter = delimiters.lookupTableParser
let relation = relations.lookupTableParser(trfOperator)
let textOp = textOperators.lookupTableParser(trfWord)

let frac = (s"\frac" | s"\tfrac" | s"\dfrac" | s"\cfrac") >> (atom & atom).map(fraction => (
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

let binom = (s"\binom" | s"\tbinom" | s"\dbinom" | s"\cbinom") >> (atom & atom).map(nk => (
  let n = nk[0]
  let k = nk[1]
  let inside = stack(n, k, n.height, saCenter)
  join(
    bigDelimiter("(", inside.height, inside.baseline),
    inside,
    bigDelimiter(")", inside.height, inside.baseline),
  )
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

let leftright = (s"\left" >> ws >> delimiter & (ws >> expr) & (s"\right" >> ws >> delimiter)).map(things => (
  let inside = things[1]
  var left = things[0]
  var right = things[2]
  if inside.height > 1:
    left = left.rows[0].bigDelimiter(inside.height, inside.baseline)
    right = right.rows[0].bigDelimiter(inside.height, inside.baseline)
  join(left, inside, right)
))

let bracedExpr = c('{') >> expr << c('}')
let atom1 = (
  bracedExpr |
  leftright |
  digit |
  latinLetter |
  otherLetter |
  binaryOp |
  delimiter |
  relation |
  textOp |
  frac |
  binom |
  sqrt
) << ws

let superscript = (c('^') >> atom1).map(sup => sup.withFlag(trfSup))
let subscript = (c('_') >> atom1).map(sub => sub.withFlag(trfSub))
atom.become (atom1 & ((superscript & subscript.optional) | (subscript & superscript.optional)).optional).map(operands => (
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
