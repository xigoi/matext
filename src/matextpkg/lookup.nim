import ./textrect
import std/sequtils
import std/tables
import std/unicode

type
  Font* = enum
    fItalic
    fBold
    fScript
    fFraktur
    fDoubleStruck

func textRects(flag: TextRectFlag, table: openArray[(string, string)]): seq[(string, TextRect)] =
  table.mapIt((it[0], it[1].toTextRect(flag = flag)))

const bigOperators = textRects(trfBigOperator, {
  "\\sum": "∑", "\\prod": "∏", "\\bigotimes": "⨂", "\\bigvee": "⋁",
  "\\int": "∫", "\\coprod": "∐", "\\bigoplus": "⨁", "\\bigwedge": "⋀",
  "\\iint": "∬", "\\intop": "∫", "\\bigodot": "⨀", "\\bigcap": "⋂",
  "\\iiint": "∭", "\\smallint": "∫", "\\biguplus": "⨄", "\\bigcup": "⋃",
  "\\oint": "∮", "\\oiint": "∯", "\\oiiint": "∰", "\\bigsqcup": "⨆",
})

const binaryOperators = textRects(trfOperator, {
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
  "\\forall": "∀", "\\complement": "∁", "\\therefore": "∴", "\\emptyset": "∅",
  "\\exists": "∃", "\\subset": "⊂", "\\because": "∵", "\\empty": "∅",
  "\\exist": "∃", "\\supset": "⊃", "\\mapsto": "↦", "\\varnothing": "∅",
  "\\nexists": "∄", "\\mid": "∣", "\\to": "→", "\\implies": "⟹",
  "\\in": "∈", "\\land": "∧", "\\gets": "←", "\\impliedby": "⟸",
  "\\isin": "∈", "\\lor": "∨", "\\leftrightarrow": "↔", "\\iff": "⟺",
  "\\notin": "∉", "\\ni": "∋", "\\notni": "∌", "\\neg": "¬", "\\lnot": "¬",
  "\\circlearrowleft": "↺", "\\leftharpoonup": "↼", "\\rArr": "⇒",
  "\\circlearrowright": "↻", "\\leftleftarrows": "⇇", "\\rarr": "→",
  "\\curvearrowleft": "↶", "\\leftrightarrow": "↔", "\\restriction": "↾",
  "\\curvearrowright": "↷", "\\Leftrightarrow": "⇔", "\\rightarrow": "→",
  "\\Darr": "⇓", "\\leftrightarrows": "⇆", "\\Rightarrow": "⇒",
  "\\dArr": "⇓", "\\leftrightharpoons": "⇋", "\\rightarrowtail": "↣",
  "\\darr": "↓", "\\leftrightsquigarrow": "↭", "\\rightharpoondown": "⇁",
  "\\dashleftarrow": "⇠", "\\Lleftarrow": "⇚", "\\rightharpoonup": "⇀",
  "\\dashrightarrow": "⇢", "\\longleftarrow": "⟵", "\\rightleftarrows": "⇄",
  "\\downarrow": "↓", "\\Longleftarrow": "⟸", "\\rightleftharpoons": "⇌",
  "\\Downarrow": "⇓", "\\longleftrightarrow": "⟷", "\\rightrightarrows": "⇉",
  "\\downdownarrows": "⇊", "\\Longleftrightarrow": "⟺", "\\rightsquigarrow": "⇝",
  "\\downharpoonleft": "⇃", "\\longmapsto": "⟼", "\\Rrightarrow": "⇛",
  "\\downharpoonright": "⇂", "\\longrightarrow": "⟶", "\\Rsh": "↱",
  "\\gets": "←", "\\Longrightarrow": "⟹", "\\searrow": "↘",
  "\\Harr": "⇔", "\\looparrowleft": "↫", "\\swarrow": "↙",
  "\\hArr": "⇔", "\\looparrowright": "↬", "\\to": "→",
  "\\harr": "↔", "\\Lrarr": "⇔", "\\twoheadleftarrow": "↞",
  "\\hookleftarrow": "↩", "\\lrArr": "⇔", "\\twoheadrightarrow": "↠",
  "\\hookrightarrow": "↪", "\\lrarr": "↔", "\\Uarr": "⇑",
  "\\Lsh": "↰", "\\uArr": "⇑",
  "\\mapsto": "↦", "\\uarr": "↑",
  "\\nearrow": "↗", "\\uparrow": "↑",
  "\\Larr": "⇐", "\\nleftarrow": "↚", "\\Uparrow": "⇑",
  "\\lArr": "⇐", "\\nLeftarrow": "⇍", "\\updownarrow": "↕",
  "\\larr": "←", "\\nleftrightarrow": "↮", "\\Updownarrow": "⇕",
  "\\leadsto": "⇝", "\\nLeftrightarrow": "⇎", "\\upharpoonleft": "↿",
  "\\leftarrow": "←", "\\nrightarrow": "↛", "\\upharpoonright": "↾",
  "\\Leftarrow": "⇐", "\\nRightarrow": "⇏", "\\upuparrows": "⇈",
  "\\leftarrowtail": "↢", "\\nwarrow": "↖",
  "\\leftharpoondown": "↽", "\\Rarr": "⇒",
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
  "\\gnapprox": "⪊", "\\ngeqslant": "≱", "\\nsubseteq": "⊈", "\\precneqq": "⪵",
  "\\gneq": "⪈", "\\ngtr": "≯", "\\nsubseteqq": "⊈", "\\precnsim": "⋨",
  "\\gneqq": "≩", "\\nleq": "≰", "\\nsucc": "⊁", "\\subsetneq": "⊊",
  "\\gnsim": "⋧", "\\nleqq": "≰", "\\nsucceq": "⋡", "\\subsetneqq": "⫋",
  "\\gvertneqq": "≩", "\\nleqslant": "≰", "\\nsupseteq": "⊉", "\\succnapprox": "⪺",
  "\\lnapprox": "⪉", "\\nless": "≮", "\\nsupseteqq": "⊉", "\\succneqq": "⪶",
  "\\lneq": "⪇", "\\nmid": "∤", "\\ntriangleleft": "⋪", "\\succnsim": "⋩",
  "\\lneqq": "≨", "\\notin": "∉", "\\ntrianglelefteq": "⋬", "\\supsetneq": "⊋",
  "\\lnsim": "⋦", "\\notni": "∌", "\\ntriangleright": "⋫", "\\supsetneqq": "⫌",
  "\\lvertneqq": "≨", "\\nparallel": "∦", "\\ntrianglerighteq": "⋭", "\\varsubsetneq": "⊊",
  "\\ncong": "≆", "\\nprec": "⊀", "\\nvdash": "⊬", "\\varsubsetneqq": "⫋",
  "\\ne": "≠", "\\npreceq": "⋠", "\\nvDash": "⊭", "\\varsupsetneq": "⊋",
  "\\neq": "≠", "\\nshortmid": "∤", "\\nVDash": "⊯", "\\varsupsetneqq": "⫌",
  "\\ngeq": "≱", "\\nshortparallel": "∦", "\\nVdash": "⊮",
  "\\ngeqq": "≱", "\\nsim": "≁", "\\precnapprox": "⪹",
})

const delimiters* = textRects(trfNone, {
  "(": "(",
  "\\lparen": "(",
  ")": ")",
  "\\rparen": ")",
  "[": "[",
  "\\lbrack": "[",
  "]": "]",
  "\\rbrack": "]",
  "\\{": "{",
  "\\lbrace": "{",
  "\\}": "}",
  "\\rbrace": "}",
  "⟨": "⟨",
  "\\langle": "⟨",
  "\\lang": "⟨",
  "⟩": "⟩",
  "\\rangle": "⟩",
  "\\rang": "⟩",
  "|": "∣",
  "\\vert": "∣",
  "\\|": "∥",
  "\\Vert": "∥",
  "⌈": "⌈",
  "\\lceil": "⌈",
  "⌉": "⌉",
  "\\rceil": "⌉",
  "⌊": "⌊",
  "\\lfloor": "⌊",
  "⌋": "⌋",
  "\\rfloor": "⌋",
  "⟦": "⟦",
  "\\llbracket": "⟦",
  "⟧": "⟧",
  "\\rrbracket": "⟧",
})

const fontsByName* = {
  "\\mathit": fItalic,
  "\\mathbf": fBold,
  "\\mathcal": fScript,
  "\\mathfrak": fFraktur,
  "\\mathbb": fDoubleStruck,
}

const fontStarts* = [
  fItalic: 119860,
  fBold: 119808,
  fScript: 119964,
  fFraktur: 120068,
  fDoubleStruck: 120120,
]

const fontExceptions* = [
  fItalic: @{'h': "ℎ"},
  fBold: @[],
  fScript: @{
    'B': "ℬ",
    'E': "ℰ",
    'F': "ℱ",
    'H': "ℋ",
    'I': "ℐ",
    'L': "ℒ",
    'M': "ℳ",
    'R': "ℛ",
    'e': "ℯ",
    'g': "ℊ",
    'o': "ℴ",
  },
  fFraktur: @{
    'C': "ℭ",
    'H': "ℌ",
    'I': "ℑ",
    'R': "ℜ",
    'Z': "ℨ",
  },
  fDoubleStruck: @{
    'C': "ℂ",
    'H': "ℍ",
    'N': "ℕ",
    'P': "ℙ",
    'Q': "ℚ",
    'R': "ℝ",
    'Z': "ℤ",
  },
]

func inFont*(letter: char, font: Font): string =
  for (lhs, rhs) in fontExceptions[font]:
    if letter == lhs:
      return rhs
  let shift = if letter in 'A'..'Z': 65 else: 71
  return $Rune(fontStarts[font] + letter.ord - shift)

# TODO: make Greek letters italic
const letters = textRects(trfAlnum, {
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
})

const punctuation = textRects(trfPunctuation, {
  ",": ",",
  ":": ":",
})

const simpleDiacritics* = {
  "\\acute": (combining: "\u0301", low: "ˏ"),
  "\\bar": (combining: "\u0304", low: "_"),
  "\\breve": (combining: "\u0306", low: "⏑"),
  "\\check": (combining: "\u030C", low: "ˇ"),
  "\\dot": (combining: "\u0307", low: "."),
  "\\ddot": (combining: "\u0308", low: "¨"),
  "\\grave": (combining: "\u0300", low: "ˎ"),
  "\\hat": (combining: "\u0302", low: "ꞈ"),
  "\\not": (combining: "\u0338", low: "/"),
  "\\tilde": (combining: "\u0303", low: "˷"),
  "\\vec": (combining: "\u20D7", low: "→")
}

const superscripts* = {
  "0".runeAt(0): "⁰",
  "1".runeAt(0): "¹",
  "2".runeAt(0): "²",
  "3".runeAt(0): "³",
  "4".runeAt(0): "⁴",
  "5".runeAt(0): "⁵",
  "6".runeAt(0): "⁶",
  "7".runeAt(0): "⁷",
  "8".runeAt(0): "⁸",
  "9".runeAt(0): "⁹",
  "+".runeAt(0): "⁺",
  "−".runeAt(0): "⁻",
  "=".runeAt(0): "⁼",
  "(".runeAt(0): "⁽",
  ")".runeAt(0): "⁾",
  "i".runeAt(0): "ⁱ",
  "n".runeAt(0): "ⁿ",
  " ".runeAt(0): "",
}.toTable

const subscripts* = {
  "0".runeAt(0): "₀",
  "1".runeAt(0): "₁",
  "2".runeAt(0): "₂",
  "3".runeAt(0): "₃",
  "4".runeAt(0): "₄",
  "5".runeAt(0): "₅",
  "6".runeAt(0): "₆",
  "7".runeAt(0): "₇",
  "8".runeAt(0): "₈",
  "9".runeAt(0): "₉",
  "+".runeAt(0): "₊",
  "-".runeAt(0): "₋",
  "=".runeAt(0): "₌",
  "(".runeAt(0): "₍",
  ")".runeAt(0): "₎",
  "a".runeAt(0): "ₐ",
  "e".runeAt(0): "ₑ",
  "o".runeAt(0): "ₒ",
  "x".runeAt(0): "ₓ",
  "h".runeAt(0): "ₕ",
  "k".runeAt(0): "ₖ",
  "l".runeAt(0): "ₗ",
  "m".runeAt(0): "ₘ",
  "n".runeAt(0): "ₙ",
  "p".runeAt(0): "ₚ",
  "s".runeAt(0): "ₛ",
  "t".runeAt(0): "ₜ",
  "i".runeAt(0): "ᵢ",
  "r".runeAt(0): "ᵣ",
  "j".runeAt(0): "ⱼ",
  "u".runeAt(0): "ᵤ",
  "β".runeAt(0): "ᵦ",
  "v".runeAt(0): "ᵥ",
  "χ".runeAt(0): "ᵪ",
  "γ".runeAt(0): "ᵧ",
  "ρ".runeAt(0): "ᵨ",
  "φ".runeAt(0): "ᵩ",
  " ".runeAt(0): "",
}.toTable

const symbols = textRects(trfNone, {
  "\\dots": "…", "\\KaTeX": "K T X\n A E ",
  "\\%": "%", "\\cdots": "⋯", "\\LaTeX": "L T X\n A E ",
  "\\#": "#", "\\ddots": "⋱", "\\TeX": "T X\n E ",
  "\\&": "&", "\\ldots": "…", "\\nabla": "∇",
  "\\_": "_", "\\vdots": "⋮", "\\infty": "∞",
  "\\textunderscore": "_", "\\dotsb": "⋯", "\\infin": "∞",
  "\\--": "–", "\\dotsc": "…", "\\checkmark": "✓",
  "\\textendash": "–", "\\dotsi": "⋯", "\\dag": "†",
  "\\---": "—", "\\dotsm": "⋯", "\\dagger": "†",
  "\\textemdash": "—", "\\dotso": "…", "\\textdagger": "†",
  "\\textasciitilde": "~", "\\sdot": "⋅", "\\ddag": "‡",
  "\\textasciicircum": "^", "\\mathellipsis": "…", "\\ddagger": "‡",
  "`": "‘", "\\textellipsis": "…", "\\textdaggerdbl": "‡",
  "\\textquoteleft": "‘", "\\Box": "□", "\\Dagger": "‡",
  "\\lq": "‘", "\\square": "□", "\\angle": "∠",
  "\\textquoteright": "’", "\\blacksquare": "■", "\\measuredangle": "∡",
  "\\rq": "′", "\\triangle": "△", "\\sphericalangle": "∢",
  "\\textquotedblleft": "“", "\\triangledown": "▽", "\\top": "⊤",
  "\"": "\"",  "\\triangleleft": "◃", "\\bot": "⊥",
  "\\textquotedblright": "”", "\\triangleright": "▹", "\\$": "$",
  "\\colon": ":", "\\bigtriangledown": "▽", "\\textdollar": "$",
  "\\backprime": "‵", "\\bigtriangleup": "△", "\\pounds": "£",
  "\\prime": "′", "\\blacktriangle": "▲", "\\mathsterling": "£",
  "\\textless": "<", "\\blacktriangledown": "▼", "\\textsterling": "£",
  "\\textgreater": ">", "\\blacktriangleleft": "◀", "\\yen": "¥",
  "\\textbar": "|", "\\blacktriangleright": "▶", "\\surd": "√",
  "\\textbardbl": "∥", "\\diamond": "⋄", "\\degree": "°",
  "\\textbraceleft": "{", "\\Diamond": "◊", "\\textdegree": "°",
  "\\textbraceright": "}", "\\lozenge": "◊", "\\mho": "℧",
  "\\textbackslash": "\\", "\\blacklozenge": "⧫", "\\diagdown": "╲",
  "\\P": "¶", "\\star": "⋆", "\\diagup": "╱",
  "\\S": "§", "\\bigstar": "★", "\\flat": "♭",
  "\\sect": "§", "\\clubsuit": "♣", "\\natural": "♮",
  "\\copyright": "©", "\\clubs": "♣", "\\sharp": "♯",
  "\\circledR": "®", "\\diamondsuit": "♢", "\\heartsuit": "♡",
  "\\textregistered": "®", "\\diamonds": "♢", "\\hearts": "♡",
  "\\circledS": "Ⓢ", "\\spadesuit": "♠", "\\spades": "♠",
  "\\maltese": "✠", "\\minuso": "⦵",
})

const textOperators = textRects(trfWord, {
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
})

func isCommand(key: string): bool =
  key[0] == '\\' and (key[1] in 'a'..'z' or key[1] in 'A'..'Z')

const commands* = block:
  var commands = initTable[string, TextRect]()
  proc extractCommands(table: openArray[(string, TextRect)]) =
    for (key, val) in table:
      if key.isCommand:
        commands[key[1..^1]] = val
  extractCommands bigOperators
  extractCommands binaryOperators
  extractCommands delimiters
  extractCommands letters
  extractCommands punctuation
  extractCommands symbols
  extractCommands textOperators
  commands

const nonCommands* = block:
  var nonCommands = newSeq[(string, TextRect)]()
  proc extractNonCommands(table: openArray[(string, TextRect)]) =
    for (key, val) in table:
      if not key.isCommand:
        nonCommands.add((key, val))
  extractNonCommands bigOperators
  extractNonCommands binaryOperators
  extractNonCommands delimiters
  extractNonCommands letters
  extractNonCommands punctuation
  extractNonCommands symbols
  extractNonCommands textOperators
  nonCommands
