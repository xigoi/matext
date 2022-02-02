import std/sequtils
import std/strutils

type
  TextRect* = object
    rows: seq[string]
    baseline: Natural

using rect: TextRect

func `$`*(rect): string =
  rect.rows.join("\n")

func width*(rect): Natural =
  rect.rows[0].len

func height*(rect): Natural =
  rect.rows.len

func toTextRect*(s: string, baseline: Natural = 0): TextRect =
  if s == "":
    raise newException(ValueError, "A TextRect must not be empty")
  result.rows = s.split("\n")
  let width = result.width
  for row in result.rows:
    if row.len != width:
      raise newException(ValueError, "All rows of a TextRect must be the same width")
  result.baseline = baseline

func extendUp(rect; num: Natural): TextRect =
  result.rows = sequtils.repeat(' '.repeat(rect.width), num) & rect.rows
  result.baseline = rect.baseline + num

func extendDown(rect; num: Natural): TextRect =
  result.rows = rect.rows & sequtils.repeat(' '.repeat(rect.width), num)
  result.baseline = rect.baseline

func `&`*(left, right: TextRect): TextRect =
  let diff1 = left.baseline - right.baseline
  let left1 = left.extendUp(max(0, -diff1))
  let right1 = right.extendUp(max(0, diff1))
  assert left1.baseline == right1.baseline
  let diff2 = left1.height - right1.height
  let left2 = left1.extendDown(max(0, -diff2))
  let right2 = right1.extendDown(max(0, diff2))
  assert left2.height == right2.height
  result.rows = newSeq[string](left2.height)
  for i, row in result.rows.mpairs:
    row = left2.rows[i] & right2.rows[i]
  result.baseline = left2.baseline
