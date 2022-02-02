include matextpkg/textrect
import std/unittest

const rectStrings = ["hello", "ma\nth", "1234567\nqwertyu\nasdfghj\nzxcvbnm"]

test "conversion to/from string":
  for s in rectStrings:
    check $s.toTextRect == s
  const nonRectStrings = ["", "12\n3", "1234567\nqwertyu\nasdfghjk\nzxcvbnm"]
  for s in nonRectStrings:
    expect ValueError:
      discard s.toTextRect

test "horizontal joining":
  const
    hello = "hello".toTextRect
    world = "world".toTextRect
    math0 = "ma\nth".toTextRect(0)
    math1 = "ma\nth".toTextRect(1)
  check $(hello & world) == "helloworld"
  check $(hello & math0) == "helloma\n     th"
  check $(hello & math1) == "     ma\nhelloth"
  check $(math0 & world) == "maworld\nth     "
  check $(math1 & world) == "ma     \nthworld"
  check $(math0 & math0) == "mama\nthth"
  check $(math1 & math1) == "mama\nthth"
  check $(math0 & math1) == "  ma\nmath\nth  "
  check $(math1 & math0) == "ma  \nthma\n  th"
