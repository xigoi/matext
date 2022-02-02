from std/strutils import join, repeat, split
import std/sequtils
import std/sugar
import std/unicode

type
  TextRect* = object
    rows: seq[string]
    baseline: Natural
    width*: Natural
  StackAlignment* = enum
    saCenter
    saLeft
    saRight

using rect: TextRect

func `$`*(rect): string =
  rect.rows.join("\n")

func height*(rect): Natural =
  rect.rows.len

func toTextRect*(s: string, baseline: Natural = 0): TextRect =
  if s == "":
    raise newException(ValueError, "A TextRect must not be empty")
  result.rows = s.split("\n")
  result.width = result.rows[0].runeLen
  for row in result.rows:
    if row.runeLen != result.width:
      raise newException(ValueError, "All rows of a TextRect must be the same width")
  result.baseline = baseline

func extendUp(rect; num: Natural): TextRect =
  result.rows = sequtils.repeat(' '.repeat(rect.width), num) & rect.rows
  result.baseline = rect.baseline + num
  result.width = rect.width

func extendDown(rect; num: Natural): TextRect =
  result.rows = rect.rows & sequtils.repeat(' '.repeat(rect.width), num)
  result.baseline = rect.baseline
  result.width = rect.width

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
  result.width = left.width + right.width

func center(s: string, width: Natural, padding = ' '.Rune): string =
  let sLen = s.runeLen
  if sLen >= width:
    s
  else:
    let diff = width - sLen
    let left = diff div 2
    let right = diff - left
    padding.repeat(left) & s & padding.repeat(right)

func stack*(rects: varargs[TextRect], baseline: Natural, alignment: StackAlignment): TextRect =
  let width = max(rects.mapIt(it.width))
  let alignFunc = case alignment
    of saCenter: (s: string) => s.center(width)
    of saLeft:   (s: string) => s.alignLeft(width)
    of saRight:  (s: string) => s.align(width)
  for rect in rects:
    for row in rect.rows:
      result.rows.add alignFunc(row)
  result.baseline = baseline
