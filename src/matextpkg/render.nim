import ./textrect
import honeycomb
import std/sequtils
import std/strutils
import std/sugar
import std/tables

const binaryOperators = {
  "+": "+", "-": "−", "*": "∗", "/": "/",
  "\\cdot": "⋅", "\\gtrdot": "⋗",
  "\\cdotp": "⋅", "\\intercal": "⊺",
  "\\centerdot": "⋅", "\\land": "∧", "\\rhd": "⊳",
  "\\circ": "∘", "\\leftthreetimes": "⋋", "\\rightthreetimes": "⋌",
  "\\amalg": "⨿", "\\circledast": "⊛", "\\ldotp": ".", "\\rtimes": "⋊",
  "\\And": "&", "\\circledcirc": "⊚", "\\lor": "∨", "\\setminus": "∖",
  "\\ast": "∗", "\\circleddash": "⊝", "\\lessdot": "⋖", "\\smallsetminus": "∖",
  "\\barwedge": "⊼", "\\Cup": "⋓", "\\lhd": "⊲", "\\sqcap": "⊓",
  "\\bigcirc": "◯", "\\cup": "∪", "\\ltimes": "⋉", "\\sqcup": "⊔",
  "\\mod": "bmod", "\\curlyvee": "⋎", "\\times": "×",
  "\\boxdot": "⊡", "\\curlywedge": "⋏", "\\mp": "∓", "\\unlhd": "⊴",
  "\\boxminus": "⊟", "\\div": "÷", "\\odot": "⊙", "\\unrhd": "⊵",
  "\\boxplus": "⊞", "\\divideontimes": "⋇", "\\ominus": "⊖", "\\uplus": "⊎",
  "\\boxtimes": "⊠", "\\dotplus": "∔", "\\oplus": "⊕", "\\vee": "∨",
  "\\bullet": "∙", "\\doublebarwedge": "⩞", "\\otimes": "⊗", "\\veebar": "⊻",
  "\\Cap": "⋒", "\\doublecap": "⋒", "\\oslash": "⊘", "\\wedge": "∧",
  "\\cap": "∩", "\\doublecup": "⋓", "\\pm": "±", "\\plusmn": "±", "\\wr": "≀",
}
const delimiters = {
  "(": "(",
  ")": ")",
  "[": "[",
  "]": "]",
  "\\{": "{",
  "\\}": "}",
}

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
let oneChar = alphanumeric.map(ch => ($ch).toTextRect)
let binaryOp = binaryOperators.map(it => s(it[0]).result(it[1])).foldr(a | b).map(s => s.toTextRect(flag = trfOperator))
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
  result = stack(numerator, fractionLine.toTextRect, denominator, numerator.height, saCenter)
  result.flag = flag
))
let delimiter = delimiters.map(it => s(it[0]).result(it[1])).foldr(a | b).map(s => s.toTextRect)
let leftright = (s"\left" >> delimiter & expr & (s"\right" >> delimiter)).map(things => (
  let inside = things[1]
  var left = things[0]
  var right = things[2]
  if inside.height > 1:
    left = left.rows[0].bigDelimiter(inside.height, inside.baseline)
    right = right.rows[0].bigDelimiter(inside.height, inside.baseline)
  join(@[left, inside, right])
))
let bracedExpr = c('{') >> expr << c('}')
let atom1 = (bracedExpr | leftright | oneChar | binaryOp | frac) << ws
let superscript = (c('^') >> atom1).map(sup => sup.withFlag(trfSup))
let subscript = (c('_') >> atom1).map(sub => sub.withFlag(trfSub))
atom.become (atom1 & ((superscript & subscript) | (subscript & superscript) | superscript.asSeq | subscript.asSeq).optional).map(operands => (
  let base = operands[0]
  case operands.len
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
))
let completeExpr = expr << eof

proc render*(latex: string): string =
  let parsed = completeExpr.parse(latex)
  if parsed.kind == success:
    $parsed.value
  else:
    raise newException(ValueError, "Can't parse expression")
