include matextpkg/textrect
import std/unittest

test "conversion to/from string":
  const rectStrings = ["", "hello", "ma\nth", "1234567\nqwertyu\nasdfghj\nzxcvbnm"]
  for s in rectStrings:
    check $s.toTextRect == s
  const nonRectStrings = ["12\n3", "1234567\nqwertyu\nasdfghjk\nzxcvbnm"]
  for s in nonRectStrings:
    expect ValueError:
      discard s.toTextRect

const
  hello = "hello".toTextRect
  world = "world".toTextRect
  math0 = "ma\nth".toTextRect(0)
  math1 = "ma\nth".toTextRect(1)

test "horizontal joining":
  check $(hello & world) == "helloworld"
  check $(hello & math0) == "helloma\n     th"
  check $(hello & math1) == "     ma\nhelloth"
  check $(math0 & world) == "maworld\nth     "
  check $(math1 & world) == "ma     \nthworld"
  check $(math0 & math0) == "mama\nthth"
  check $(math1 & math1) == "mama\nthth"
  check $(math0 & math1) == "  ma\nmath\nth  "
  check $(math1 & math0) == "ma  \nthma\n  th"

test "custom center func":
  let abc = "ábč"
  for width in 0..3:
    check abc.center(width) == abc
  check abc.center(4) == "ábč "
  check abc.center(5) == " ábč "
  check abc.center(6) == " ábč  "
  check abc.center(7) == "  ábč  "

test "vertical joining":
  for rect in [hello, world, math0, math1]:
    for alignment in StackAlignment:
      check $stack(rect, 0, alignment) == $rect
  for alignment in StackAlignment:
    check $stack(hello, world, 0, alignment) == "hello\nworld"
  check $stack(hello, math0, 0, saCenter) == "hello\n ma  \n th  "
  check $stack(hello, math0, 0, saLeft)   == "hello\nma   \nth   "
  check $stack(hello, math0, 0, saRight)  == "hello\n   ma\n   th"
  check $stack(math0, world, 0, saCenter) == " ma  \n th  \nworld"
  check $stack(math0, world, 0, saLeft)   == "ma   \nth   \nworld"
  check $stack(math0, world, 0, saRight)  == "   ma\n   th\nworld"
  check $stack(hello, math0 & math1, hello & world, 0, saCenter) == "  hello   \n     ma   \n   math   \n   th     \nhelloworld"
