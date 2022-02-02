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

var atom = fwdcl[TextRect]()
let expr = atom.atLeast(1).map(atoms => atoms.join)
let oneChar = alphanumeric.map(ch => ($ch).toTextRect)
let binaryOp = (
  c"+-*/".map(ch => $ch) |
  binaryOperators.map(it => s(it.cmd).result(it.op)).foldr(a | b)
).map(s => s.toTextRect(flag = trfOperator))
let frac = s"\frac" >> (atom & atom).map((fraction: seq[TextRect]) => (
  let numerator = fraction[0]
  let denominator = fraction[1]
  let fractionLine = "─".repeat(max(numerator.width, denominator.width)).toTextRect
  stack(numerator, fractionLine, denominator, numerator.height, saCenter)
))
let bracedExpr = c('{') >> expr << c('}')
atom.become (bracedExpr | oneChar | binaryOp | frac) << whitespace.many
echo expr.parse("\\frac{11 \\cdot 2}{3 + 4}").value
