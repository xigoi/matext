from std/strutils import join, repeat, split
import std/math
import std/sequtils
import std/sugar
import std/unicode

type
  TextRectFlag* = enum
    trfNone
    trfAlnum
    trfOperator
    trfBigOperator
    trfWord
    trfFraction
    trfSub
    trfSup
    trfPunctuation
  TextRect* = object
    rows*: seq[string]
    baseline*: int
    width*: Natural
    flag*: TextRectFlag
  StackAlignment* = enum
    saCenter
    saLeft
    saRight

using rect: TextRect

func `$`*(rect): string =
  rect.rows.join("\n")

func row*(rect): string =
  rect.rows[0]

func rowAsAtom*(rect): string =
  if rect.rows[0].runeLen == 1:
    rect.rows[0]
  else:
    "(" & rect.rows[0] & ")"

func height*(rect): Natural =
  rect.rows.len

func isEmpty*(rect): bool =
  rect.height == 0

func toTextRect*(s: string, baseline: int = 0, flag = trfNone): TextRect =
  if s == "":
    result.flag = flag
    return
  result.rows = s.split("\n")
  result.width = result.rows[0].runeLen
  for row in result.rows:
    if row.runeLen != result.width:
      raise newException(ValueError, "All rows of a TextRect must be the same width")
  result.baseline = baseline
  result.flag = flag

func toTextRectOneLine*(s: string, baseline: int = 0, flag = trfNone): TextRect =
  if s == "":
    result.flag = flag
    return
  result.rows = @[s]
  result.width = s.runeLen
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

func extendLeft(rect: var TextRect) =
  for row in rect.rows.mitems:
    row = " " & row
  rect.width.inc

func extendRight(rect: var TextRect) =
  for row in rect.rows.mitems:
    row &= " "
  rect.width.inc

func join*(rects: varargs[TextRect]): TextRect =
  var rects = rects.toSeq
  rects.keepItIf(not it.isEmpty)
  if rects == @[]:
    return
  if rects.len == 1:
    return rects[0]
  for i, rect in rects.mpairs:
    case rect.flag
    of trfPunctuation:
      if i != rects.high:
        rect.extendRight
    of trfOperator, trfBigOperator:
      if i != rects.high:
        rect.extendRight
      if i != rects.low and rects[i - 1].flag notin {trfOperator, trfBigOperator, trfPunctuation}:
        rect.extendLeft
    of trfWord:
      if i != rects.high and rects[i + 1].flag in {trfAlnum, trfWord}:
        rect.extendRight
      if i != rects.low and rects[i - 1].flag in {trfAlnum}:
        rect.extendLeft
    else:
      discard
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

const alignFuncs = [
  saCenter: (s: string, width: int) => s.center(width),
  saLeft:   (s: string, width: int) => s.alignLeft(width),
  saRight:  (s: string, width: int) => s.align(width),
]

proc stack*(rects: varargs[TextRect], baseline: int, alignment: StackAlignment): TextRect =
  let width = max(rects.mapIt(it.width))
  let alignFunc = alignFuncs[alignment]
  for rect in rects:
    for row in rect.rows:
      result.rows.add alignFunc(row, width)
  result.baseline = baseline
  result.width = width

func withFlag*(rect; flag: TextRectFlag): TextRect =
  result = rect
  result.flag = flag
