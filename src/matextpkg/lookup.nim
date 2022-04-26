const binaryOperators* = {
  "+": "+", "-": "−", "*": "∗", "/": "/",
  "\\cdot": "⋅", "\\gtrdot": "⋗",
  "\\cdotp": "⋅", "\\intercal": "⊺",
  "\\centerdot": "⋅", "\\land": "∧", "\\rhd": "⊳",
  "\\circ": "∘", "\\leftthreetimes": "⋋", "\\rightthreetimes": "⋌",
  "\\amalg": "⨿", "\\circledast": "⊛", "\\ldotp": ".", "\\rtimes": "⋊",
  "\\And": "&", "\\circledcirc": "⊚", "\\lor": "∨", "\\setminus": "∖",
  "\\ast": "∗", "\\circleddash": "⊝", "\\lessdot": "⋖", "\\smallsetminus": "∖",
  "\\barwedge": "⊼", "\\Cup": "⋓", "\\lhd": "⊲", "\\sqcap": "⊓",
  "\\bigcirc": "◯", "\\cup": "∪", "\\ltimes": "⋉", "\\sqcup": "⊔",
  "\\mod": "bmod", "\\curlyvee": "⋎", "\\times": "×",
  "\\boxdot": "⊡", "\\curlywedge": "⋏", "\\mp": "∓", "\\unlhd": "⊴",
  "\\boxminus": "⊟", "\\div": "÷", "\\odot": "⊙", "\\unrhd": "⊵",
  "\\boxplus": "⊞", "\\divideontimes": "⋇", "\\ominus": "⊖", "\\uplus": "⊎",
  "\\boxtimes": "⊠", "\\dotplus": "∔", "\\oplus": "⊕", "\\vee": "∨",
  "\\bullet": "∙", "\\doublebarwedge": "⩞", "\\otimes": "⊗", "\\veebar": "⊻",
  "\\Cap": "⋒", "\\doublecap": "⋒", "\\oslash": "⊘", "\\wedge": "∧",
  "\\cap": "∩", "\\doublecup": "⋓", "\\pm": "±", "\\plusmn": "±", "\\wr": "≀",
}
const relations* = {
  "=": "=", "\\doteqdot": "≑", "\\lessapprox": "⪅", "\\smile": "⌣",
  "<": "<", "\\eqcirc": "≖", "\\lesseqgtr": "⋚", "\\sqsubset": "⊏",
  "\\eqcolon": ">>> >, ∹", "\\minuscolon": "∹", ">": ">", "\\lesseqqgtr": "⪋", "\\sqsubseteq": "⊑",
  "\\Eqcolon": "::: :, −∷", "\\minuscoloncolon": "::: :, −∷", "\\lessgtr": "≶", "\\sqsupset": "⊐",
  "\\eqqcolon": "≕", "\\equalscolon": "≕", "\\approx": "≈", "\\lesssim": "≲", "\\sqsupseteq": "⊒",
  "\\Eqqcolon": "=∷", "\equalscoloncolon": "=∷", "\\approxcolon": "≈:", "\\ll": "≪", "\\Subset": "⋐",
  "\approxcoloncolon": "≈∷", "\\eqsim": "≂", "\\lll": "⋘", "\\subset": "⊂", "\\sub": "⊂",
  "\\approxeq": "≊", "\\eqslantgtr": "⪖", "\\llless": "⋘", "\\subseteq": "⊆", "\\sube": "⊆",
  "\\asymp": "≍", "\\eqslantless": "⪕", "\\lt": "<", "\\subseteqq": "⫅",
  "\\backepsilon": "∍", "\\equiv": "≡", "\\mid": "∣", "\\succ": "≻",
  "\\backsim": "∽", "\\fallingdotseq": "≒", "\\models": "⊨", "\\succapprox": "⪸",
  "\\backsimeq": "⋍", "\\frown": "⌢", "\\multimap": "⊸", "\\succcurlyeq": "≽",
  "\\between": "≬", "\\ge": "≥", "\\origof": "⊶", "\\succeq": "⪰",
  "\\bowtie": "⋈", "\\geq": "≥", "\\owns": "∋", "\\succsim": "≿",
  "\\bumpeq": "≏", "\\geqq": "≧", "\\parallel": "∥", "\\Supset": "⋑",
  "\\Bumpeq": "≎", "\\geqslant": "⩾", "\\perp": "⊥", "\\supset": "⊃",
  "\\circeq": "≗", "\\gg": "≫", "\\pitchfork": "⋔", "\\supseteq": "⊇", "\\supe": "⊇",
  "\\colonapprox": ":≈", "\\ggg": "⋙", "\\prec": "≺", "\\supseteqq": "⫆",
  "\\Colonapprox": "∷≈", "\coloncolonapprox": "∷≈", "\\gggtr": "⋙", "\\precapprox": "⪷", "\\thickapprox": "≈",
  "\\coloneq": ":−", "\\colonminus": ":−", "\\gt": ">", "\\preccurlyeq": "≼", "\\thicksim": "∼",
  "\\Coloneq": "∷−", "\coloncolonminus": "∷−", "\\gtrapprox": "⪆", "\\preceq": "⪯", "\\trianglelefteq": "⊴",
  "\\coloneqq": "≔", "\colonequals": "≔", "\\gtreqless": "⋛", "\\precsim": "≾", "\\triangleq": "≜",
  "\\Coloneqq": "∷=", "\coloncolonequals": "∷=", "\\gtreqqless": "⪌", "\\propto": "∝", "\\trianglerighteq": "⊵",
  "\\colonsim": ":∼", "\\gtrless": "≷", "\\risingdotseq": "≓", "\\varpropto": "∝",
  "\\Colonsim": "∷∼", "\coloncolonsim": "∷∼", "\\gtrsim": "≳", "\\shortmid": "∣", "\\vartriangle": "△",
  "\\cong": "≅", "\\imageof": "⊷", "\\shortparallel": "∥", "\\vartriangleleft": "⊲",
  "\\curlyeqprec": "⋞", "\\in": "∈", "\\isin": "∈", "\\sim": "∼", "\\vartriangleright": "⊳",
  "\\curlyeqsucc": "⋟", "\\Join": "⋈", "\\simcolon": "∼:", "\\vcentcolon": ":", "\\ratio": ":",
  "\\dashv": "⊣", "\\le": "≤", "\\simcoloncolon": "∼∷", "\\vdash": "⊢",
  "\\dblcolon": "∷", "\coloncolon": "∷", "\\leq": "≤", "\\simeq": "≃", "\\vDash": "⊨",
  "\\doteq": "≐", "\\leqq": "≦", "\\smallfrown": "⌢", "\\Vdash": "⊩",
  "\\Doteq": "≑", "\\leqslant": "⩽", "\\smallsmile": "⌣", "\\Vvdash": "⊪",
}
const delimiters* = {
  "(": "(",
  ")": ")",
  "[": "[",
  "]": "]",
  "\\{": "{",
  "\\}": "}",
  "⟨": "⟨",
  "\\langle": "⟨",
  "\\lang": "⟨",
  "⟩": "⟩",
  "\\rangle": "⟩",
  "\\rang": "⟩",
}
const textOperators* = {
  "\\arcsin": "arcsin", "\\cosec": "cosec", "\\deg": "deg", "\\sec": "sec",
  "\\arccos": "arccos", "\\cosh": "cosh", "\\dim": "dim", "\\sin": "sin",
  "\\arctan": "arctan", "\\cot": "cot", "\\exp": "exp", "\\sinh": "sinh",
  "\\arctg": "arctg", "\\cotg": "cotg", "\\hom": "hom", "\\sh": "sh",
  "\\arcctg": "arcctg", "\\coth": "coth", "\\ker": "ker", "\\tan": "tan",
  "\\arg": "arg", "\\csc": "csc", "\\lg": "lg", "\\tanh": "tanh",
  "\\ch": "ch", "\\ctg": "ctg", "\\ln": "ln", "\\tg": "tg",
  "\\cos": "cos", "\\cth": "cth", "\\log": "log", "\\th": "th",
  "\\argmax": "arg max", "\\injlim": "inj lim", "\\min": "min",
  "\\argmin": "arg min", "\\lim": "lim", "\\plim": "plim",
  "\\det": "det", "\\liminf": "lim inf", "\\Pr": "Pr",
  "\\gcd": "gcd", "\\limsup": "lim sup", "\\projlim": "proj lim",
  "\\inf": "inf", "\\max": "max", "\\sup": "sup",
}
# TODO: make Greek letters italic
const letters* = {
  "\\Alpha": "A", "\\Beta": "B", "\\Gamma": "Γ", "\\Delta": "Δ",
  "\\Epsilon": "E", "\\Zeta": "Z", "\\Eta": "H", "\\Theta": "Θ",
  "\\Iota": "I", "\\Kappa": "K", "\\Lambda": "Λ", "\\Mu": "M",
  "\\Nu": "N", "\\Xi": "Ξ", "\\Omicron": "O", "\\Pi": "Π",
  "\\Rho": "P", "\\Sigma": "Σ", "\\Tau": "T", "\\Upsilon": "Υ",
  "\\Phi": "Φ", "\\Chi": "X", "\\Psi": "Ψ", "\\Omega": "Ω",
  "\\varGamma": "Γ", "\\varDelta": "Δ", "\\varTheta": "Θ", "\\varLambda": "Λ",
  "\\varXi": "Ξ", "\\varPi": "Π", "\\varSigma": "Σ", "\\varUpsilon": "Υ",
  "\\varPhi": "Φ", "\\varPsi": "Ψ", "\\varOmega": "Ω",
  "\\alpha": "α", "\\beta": "β", "\\gamma": "γ", "\\delta": "δ",
  "\\epsilon": "ϵ", "\\zeta": "ζ", "\\eta": "η", "\\theta": "θ",
  "\\iota": "ι", "\\kappa": "κ", "\\lambda": "λ", "\\mu": "μ",
  "\\nu": "ν", "\\xi": "ξ", "\\omicron": "ο", "\\pi": "π",
  "\\rho": "ρ", "\\sigma": "σ", "\\tau": "τ", "\\upsilon": "υ",
  "\\phi": "ϕ", "\\chi": "χ", "\\psi": "ψ", "\\omega": "ω",
  "\\varepsilon": "ε", "\\varkappa": "ϰ", "\\vartheta": "ϑ", "\\thetasym": "ϑ",
  "\\varpi": "ϖ", "\\varrho": "ϱ", "\\varsigma": "ς", "\\varphi": "φ",
  "\\digamma": "ϝ",
  "\\imath": "", "\\nabla": "∇", "\\Im": "ℑ", "\\Reals": "R", "\\OE": "Œ",
  "\\jmath": "ȷ", "\\partial": "∂", "\\image": "ℑ", "\\wp": "℘", "\\o": "ø",
  "\\aleph": "ℵ", "\\Game": "⅁", "\\Bbbk": "k", "\\weierp": "℘", "\\O": "Ø",
  "\\alef": "ℵ", "\\Finv": "Ⅎ", "\\N": "N", "\\Z": "Z", "\\ss": "ß",
  "\\alefsym": "ℵ", "\\cnums": "C", "\\natnums": "N", "\\aa": "å", "\\i": "ı",
  "\\beth": "ℶ", "\\Complex": "C", "\\R": "R", "\\AA": "Å", "\\j": "ȷ",
  "\\gimel": "ℷ", "\\ell": "ℓ", "\\Re": "ℜ", "\\ae": "æ",
  "\\daleth": "ℸ", "\\hbar": "ℏ", "\\real": "ℜ", "\\AE": "Æ",
  "\\eth": "ð", "\\hslash": "ℏ", "\\reals": "R", "\\oe": "œ",
}
