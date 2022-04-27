import matextpkg/render
import std/unittest
import std/strutils
import std/sequtils
import std/sugar

proc checkRender(latex: string, output: string) =
  proc canonize(s: string): string =
    s.strip(leading = false)
      .dedent
      .splitLines
      .map(ln => ln.strip(leading = false))
      .join("\n")
  check render(latex).canonize == output.canonize

test "Pythagorean Theorem":
  checkRender r"a^2 + b^2 = c^2", """
   2    2    2
  𝑎  + 𝑏  = 𝑐
  """

test "Quadratic formula":
  checkRender r"x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}", """
                ________
               ╱ 2
       − 𝑏 ± ╲╱ 𝑏  − 4𝑎𝑐
  𝑥 = ──────────────────
              2𝑎
  """

test "Pascal's triangle":
  checkRender r"\binom{n+1}{k+1} = \binom{n}{k} + \binom{n}{k+1}", """
  ⎛𝑛 + 1⎞   ⎛𝑛⎞   ⎛  𝑛  ⎞
  ⎝𝑘 + 1⎠ = ⎝𝑘⎠ + ⎝𝑘 + 1⎠
  """
