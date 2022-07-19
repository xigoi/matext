import ./lookup
import ./textrect
import honeycomb
import std/options
import std/sequtils
import std/strformat
import std/strutils
import std/sugar
import std/tables
import std/unicode

proc render*(latex: string, oneLine = false): string =

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
      "⟦": ("╓", "║", "╙"),
      "⟧": ("╖", "║", "╜"),
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

  let ws = whitespace.many
  var atom = fwdcl[TextRect]()
  let expr = atom.many.map(atoms => atoms.join)
  let alpha = c('A'..'Z') | c('a'..'z')

  let digit = c('0'..'9').map(ch => ($ch).toTextRectOneLine(0, trfAlnum))
  let latinLetter = alpha.map(letter => letter.inFont(fItalic).toTextRectOneLine(0, trfAlnum)) |
    fontsByName.map(pair => (
      let (name, font) = pair
      ((s(name) >> ws >> c('{') >> ws >> alpha << ws << c('}')) |
      (s(name) >> whitespace.atLeast(1) >> alpha))
      .map(letter => letter.inFont(font).toTextRectOneLine(0, trfAlnum))
    )).foldl(a | b)

  let delimiter =
    delimiters.map(entry => (
      let (key, val) = entry
      if key[0] == '\\':
        (s(key) << !letter).result(val)
      else:
        s(key).result(val))
    ).foldr(a | b)


  let command = (c('\\') >> letter.atLeast(1)).map(chars => chars.join).validate(name => name in commands, "a command").map(name => commands[name])
  let nonCommand =
    nonCommands.map(entry => (
      let (key, val) = entry
      s(key).result(val))
    ).foldr(a | b)

  let simpleDiacritic = simpleDiacritics.map(entry => (
    let (key, val) = entry
    (s(key) >> !letter >> ws >> atom).map(rect => (
      var rect = rect
      if rect.width == 1 and rect.height == 1:
        rect.rows[0] &= val.combining
        rect
      elif oneLine:
        fmt"{val.combining} ({rect.row})".toTextRectOneLine
      else:
        stack(val.low.toTextRectOneLine, rect, 1 + rect.baseline, saCenter)
    ))
  )).foldr(a | b)

  let frac = (s"\frac" | s"\tfrac" | s"\dfrac" | s"\cfrac") >> (atom & atom).map(fraction => (
    let numerator = fraction[0]
    let denominator = fraction[1]
    if oneLine:
      fmt"{numerator.rowAsAtom} / {denominator.rowAsAtom}".toTextRectOneLine
    else:
      let width = max(numerator.width, denominator.width)
      var fractionLine = "─".repeat(width)
      var flag = trfFraction
      if (numerator.flag == trfFraction and numerator.width == width) or
        (denominator.flag == trfFraction and denominator.width == width):
        fractionLine = "╶" & fractionLine & "╴"
        flag = trfNone
      stack(numerator, fractionLine.toTextRectOneLine, denominator, numerator.height, saCenter).withFlag(flag)
  ))

  let binom = (s"\binom" | s"\tbinom" | s"\dbinom" | s"\cbinom") >> (atom & atom).map(nk => (
    let n = nk[0]
    let k = nk[1]
    if oneLine:
      fmt"C({n.row}, {k.row})".toTextRectOneLine
    else:
      let inside = stack(n, k, n.height, saCenter)
      join(
        bigDelimiter("(", inside.height, inside.baseline),
        inside,
        bigDelimiter(")", inside.height, inside.baseline),
      )
  ))

  let boxed = s"\boxed" >> atom.map(arg => (
    if oneLine:
      fmt"[{arg.row}]".toTextRectOneLine
    else:
      let horizontal = "─".repeat(arg.width).toTextRectOneLine
      let sandwich = stack(horizontal, arg, horizontal, arg.baseline + 1, saLeft)
      var left: TextRect
      left.rows = newSeq[string](sandwich.height)
      left.width = 1
      left.baseline = sandwich.baseline
      for i in 1 ..< sandwich.height - 1:
        left.rows[i] = "│"
      var right = left
      left.rows[0] = "┌"
      left.rows[^1] = "└"
      right.rows[0] = "┐"
      right.rows[^1] = "┘"
      join(left, sandwich, right)
  ))

  let sqrt = s"\sqrt" >> atom.map(arg => (
    if oneLine:
      fmt"√{arg.rowAsAtom}".toTextRectOneLine
    else:
      let overbar = "_".repeat(arg.width).toTextRectOneLine
      let symbol =
        if arg.height == 1:
          "√".toTextRectOneLine
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
      left = left.row.bigDelimiter(inside.height, inside.baseline)
      right = right.row.bigDelimiter(inside.height, inside.baseline)
    join(left, inside, right)
  ))

  let bracedExpr = c('{') >> expr << c('}')
  let atom1 = (
    bracedExpr |
    leftright |
    digit |
    latinLetter |
    command |
    nonCommand |
    simpleDiacritic |
    frac |
    binom |
    sqrt |
    boxed
  ) << ws

  func translateIfPossible(str: string, table: Table[Rune, string]): Option[string] =
    let runes = str.runes.toSeq
    if runes.allIt(it in table):
      return some(runes.mapIt(table[it]).join)
  let superscript = (c('^') >> atom1).map(sup => sup.withFlag(trfSup)) |
    c('\'').atLeast(1).map(primes => "′".repeat(primes.len).toTextRectOneLine.withFlag(trfSup))
  let subscript = (c('_') >> atom1).map(sub => sub.withFlag(trfSub))
  atom.become (atom1 & ((superscript & subscript.optional) | (subscript & superscript.optional)).optional).map(operands => (
    var base = operands[0]
    let flag = base.flag
    base.flag = trfNone
    (case operands.len
      of 1:
        base
      of 3:
        let (sup, sub) =
          if operands[1].flag == trfSup:
            (operands[1], operands[2])
          else:
            (operands[2], operands[1])
        if oneLine:
          var str = base.row
          if not sub.isEmpty:
            str.add sub.row.translateIfPossible(subscripts).get("_" & sub.rowAsAtom)
          if not sup.isEmpty:
            str.add sup.row.translateIfPossible(superscripts).get("^" & sup.rowAsAtom)
          str.toTextRectOneLine
        elif flag in {trfBigOperator, trfWord}:
          stack(sup, base, sub, base.baseline + sup.height, saCenter)
        else:
          base & stack(sup.extendDown(base.height), sub, base.baseline + sup.height, saLeft)
      else:
        TextRect.default
    ).withFlag(flag)
  ))

  let completeExpr = expr << eof

  let parsed = completeExpr.parse(latex)
  if parsed.kind == success:
    $parsed.value
  else:
    let (lnNum, colNum) = parsed.lineInfo
    let showing = "    " & latex.splitLines[lnNum - 1] & "\n" & ' '.repeat(colNum + 3) & "^"
    raise newException(ValueError, &"Parse error at line {lnNum}, column {colNum}\n{showing}")
