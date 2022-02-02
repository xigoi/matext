import ./textrect
import honeycomb
import std/sequtils
import std/strutils
import std/sugar

var atom = fwdcl[TextRect]()
let expr = atom.atLeast(1).map(atoms => atoms.foldl(a & b))
let oneChar = alphanumeric.map(ch => ($ch).toTextRect)
let frac = s"\frac" >> (atom & atom).map((fraction: seq[TextRect]) => (
  let numerator = fraction[0]
  let denominator = fraction[1]
  let fractionLine = "─".repeat(max(numerator.width, denominator.width)).toTextRect
  stack(numerator, fractionLine, denominator, numerator.height, saCenter)
))
atom.become oneChar | frac
echo expr.parse("\\frac12").value
