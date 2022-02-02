from std/strutils import join, repeat, split
import std/math
import std/sequtils
import std/sugar
import std/unicode

type
  TextRectFlag* = enum
    trfNone
    trfOperator
    trfFraction
  TextRect* = object
    rows*: seq[string]
    baseline*: Natural
    width*: Natural
    flag*: TextRectFlag
  StackAlignment* = enum
    saCenter
    saLeft
    saRight

using rect: TextRect

func `$`*(rect): string =
  rect.rows.join("\n")

func height*(rect): Natural =
  rect.rows.len

func isEmpty(rect): bool =
  rect.height == 0

func toTextRect*(s: string, baseline: Natural = 0, flag = trfNone): TextRect =
  if s == "":
    return
  result.rows = s.split("\n")
  result.width = result.rows[0].runeLen
  for row in result.rows:
    if row.runeLen != result.width:
      raise newException(ValueError, "All rows of a TextRect must be the same width")
  result.baseline = baseline
  result.flag = flag

func extendUp*(rect; num: Natural): TextRect =
  result.rows = sequtils.repeat(' '.repeat(rect.width), num) & rect.rows
  result.baseline = rect.baseline + num
  result.width = rect.width

func extendDown*(rect; num: Natural): TextRect =
  result.rows = rect.rows & sequtils.repeat(' '.repeat(rect.width), num)
  result.baseline = rect.baseline
  result.width = rect.width

func join*(rects: varargs[TextRect]): TextRect =
  var rects = rects.toSeq
  rects.keepItIf(not it.isEmpty)
  if rects == @[]:
    return
  for rect in rects.mitems:
    if rect.flag == trfOperator:
      rect.rows[0] = " " & rect.rows[0] & " "
      rect.width += 2
  let maxBaseline = rects.mapIt(it.baseline).max
  rects.applyIt(it.extendUp(maxBaseline - it.baseline))
  let maxHeight = rects.mapIt(it.height).max
  rects.applyIt(it.extendDown(maxHeight - it.height))
  result.rows = newSeq[string](rects[0].height)
  for i, row in result.rows.mpairs:
    row = rects.mapIt(it.rows[i]).join
  result.baseline = rects[0].baseline
  result.width = rects.mapIt((it.width)).sum

func `&`*(left, right: TextRect): TextRect =
  join(left, right)

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
  result.width = width
