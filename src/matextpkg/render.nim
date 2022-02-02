import ./textrect
import honeycomb
import std/sequtils
import std/strutils
import std/sugar

const binaryOperators = {
  "cdot": "⋅", "gtrdot": "⋗",
  "cdotp": "⋅", "intercal": "⊺",
  "centerdot": "⋅", "land": "∧", "rhd": "⊳",
  "circ": "∘", "leftthreetimes": "⋋", "rightthreetimes": "⋌",
  "amalg": "⨿", "circledast": "⊛", "ldotp": ".", "rtimes": "⋊",
  "And": "&", "circledcirc": "⊚", "lor": "∨", "setminus": "∖",
  "ast": "∗", "circleddash": "⊝", "lessdot": "⋖", "smallsetminus": "∖",
  "barwedge": "⊼", "Cup": "⋓", "lhd": "⊲", "sqcap": "⊓",
  "bigcirc": "◯", "cup": "∪", "ltimes": "⋉", "sqcup": "⊔",
  "mod": "bmod", "curlyvee": "⋎", "times": "×",
  "boxdot": "⊡", "curlywedge": "⋏", "mp": "∓", "unlhd": "⊴",
  "boxminus": "⊟", "div": "÷", "odot": "⊙", "unrhd": "⊵",
  "boxplus": "⊞", "divideontimes": "⋇", "ominus": "⊖", "uplus": "⊎",
  "boxtimes": "⊠", "dotplus": "∔", "oplus": "⊕", "vee": "∨",
  "bullet": "∙", "doublebarwedge": "⩞", "otimes": "⊗", "veebar": "⊻",
  "Cap": "⋒", "doublecap": "⋒", "oslash": "⊘", "wedge": "∧",
  "cap": "∩", "doublecup": "⋓", "pm": "±", "plusmn": "±", "wr": "≀",
}.mapIt((cmd: "\\" & it[0], op: it[1]))

let ws = whitespace.many
var atom = fwdcl[TextRect]()
let expr = atom.many.map(atoms => atoms.join)
let oneChar = alphanumeric.map(ch => ($ch).toTextRect)
let binaryOp = (
  c"+-*/".map(ch => $ch) |
  binaryOperators.map(it => s(it.cmd).result(it.op)).foldr(a | b)
).map(s => s.toTextRect(flag = trfOperator))
let frac = s"\frac" >> (atom & atom).map(fraction => (
  let numerator = fraction[0]
  let denominator = fraction[1]
  let fractionLine = "─".repeat(max(numerator.width, denominator.width)).toTextRect
  stack(numerator, fractionLine, denominator, numerator.height, saCenter)
))
let bracedExpr = c('{') >> expr << c('}')
let atom1 = (bracedExpr | oneChar | binaryOp | frac) << ws
let pow = (atom1 & (c('^') >> atom)).map(operands => (
  let base = operands[0]
  var exponent = operands[1]
  exponent.baseline = exponent.height + base.height - 1
  exponent.flag = trfNone
  base & exponent
))
atom.become pow | atom1
let completeExpr = expr << eof

proc transform*(latex: string): string =
  let parsed = completeExpr.parse(latex)
  if parsed.kind == success:
    $parsed.value
  else:
    raise newException(ValueError, "Can't parse expression")
