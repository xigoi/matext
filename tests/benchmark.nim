import benchy
import matextpkg/render
import std/strutils
import std/sequtils
import std/sugar

timeIt "rendering":
  proc checkRender(latex: string, output: string) =
    proc canonize(s: string): string =
      s.strip(leading = false)
        .dedent
        .splitLines
        .map(ln => ln.strip(leading = false))
        .join("\n")
    doAssert render(latex).canonize == output.canonize

  checkRender r"a^2 + b^2 = c^2", """
   2    2    2
  𝑎  + 𝑏  = 𝑐
  """

  checkRender r"x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}", """
               ________
              ╱ 2
      − 𝑏 ± ╲╱ 𝑏  − 4𝑎𝑐
  𝑥 = ─────────────────
             2𝑎
  """

  checkRender r"\binom{n+1}{k+1} = \binom{n}{k} + \binom{n}{k+1}", """
  ⎛𝑛 + 1⎞   ⎛𝑛⎞   ⎛  𝑛  ⎞
  ⎝𝑘 + 1⎠ = ⎝𝑘⎠ + ⎝𝑘 + 1⎠
  """

  checkRender r"\boxed{e^{i \varphi} = \cos \varphi + i \sin \varphi}", """
  ┌─────────────────────┐
  │ 𝑖φ                  │
  │𝑒   = cos φ + 𝑖 sin φ│
  └─────────────────────┘
  """

  checkRender r"\left(A + B\right)^n = \sum_{k=0}^n \binom{n}{k} A^k B^{n-k}", """
         𝑛     𝑛   ⎛𝑛⎞ 𝑘 𝑛 − 𝑘
  (𝐴 + 𝐵)  =   ∑   ⎝𝑘⎠𝐴 𝐵
             𝑘 = 0
  """

  checkRender r"\iint_\Sigma \left(\nabla \times F\right) \cdot d^2 \Sigma = \oint_{\partial \Sigma} F \cdot d\Gamma", """
               2
  ∬ (∇ × 𝐹) ⋅ 𝑑 Σ = ∮  𝐹 ⋅ 𝑑Γ
  Σ                 ∂Σ
  """

  checkRender r"e = \lim_{n \to \infty} \left(1 + \frac1n \right)^n", """
                  𝑛
           ⎛    1⎞
  𝑒 =  lim ⎜1 + ─⎟
      𝑛 → ∞⎝    𝑛⎠
  """

  checkRender r"f'(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}h", """
   ′           𝑓(𝑥 + ℎ) − 𝑓(𝑥)
  𝑓 (𝑥) =  lim ───────────────
          ℎ → 0       ℎ
  """

  checkRender r"\vec x \cdot \vec y = \sum_i x_i y_i", """
  𝑥⃗ ⋅ 𝑦⃗ = ∑ 𝑥 𝑦
          𝑖  𝑖 𝑖
  """

  checkRender r"\forall \varepsilon \in \mathbb{R}^+, \exists n_0 \in \mathbb N, \forall n \in \mathbb { N } , n \ge n_0: a_n \in \left(A - \varepsilon, A + \varepsilon\right)", """
         +
  ∀ ε ∈ ℝ , ∃ 𝑛  ∈ ℕ, ∀ 𝑛 ∈ ℕ, 𝑛 ≥ 𝑛 : 𝑎  ∈ (𝐴 − ε, 𝐴 + ε)
               0                    0   𝑛
  """
