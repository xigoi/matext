import ./textrect
import std/sequtils
import std/strformat
import std/tables
import std/unicode

type
  Font* = enum
    fNone
    fItalic
    fBold
    fScript
    fFraktur
    fDoubleStruck
  LetterType = enum
    ltLatin
    ltGreek

func textRects(flag: TextRectFlag, table: openArray[(string, string)]): seq[(string, TextRect)] =
  table.mapIt((it[0], it[1].toTextRect(flag = flag)))

func rune*(s: string): Rune =
  s.runeAt(0)

func `<=`(a, b: Rune): bool {.borrow.}

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

const extensibleArrowParts* = {
  "\\xleftarrow": ("←", "←", "─", "─"),
  "\\xLeftarrow": ("⇐", "⇐", "═", "═"),
  "\\xleftrightarrow": ("↔", "←", "─", "→"),
  "\\xhookleftarrow": ("↩", "←", "─", "╯"),
  "\\xtwoheadleftarrow": ("↞", "↞", "─", "─"),
  "\\xleftharpoonup": ("↼", "↼", "─", "─"),
  "\\xleftharpoondown": ("↽", "↽", "─", "─"),
  "\\xleftrightharpoons": ("⇋", "⥪", "═", "⥭"),
  "\\xtofrom": ("⇄", "←", "═", "→"),
  "\\xlongequal": ("=", "═", "═", "═"),
  "\\xrightarrow": ("→", "─", "─", "→"),
  "\\xRightarrow": ("⇒", "═", "═", "⇒"),
  "\\xLeftrightarrow": ("⇔", "⇐", "═", "⇒"),
  "\\xhookrightarrow": ("↪", "╰", "─", "→"),
  "\\xtwoheadrightarrow": ("↠", "─", "─", "↠"),
  "\\xrightharpoonup": ("⇀", "─", "─", "⇀"),
  "\\xrightharpoondown": ("⇁", "─", "─", "⇁"),
  "\\xrightleftharpoons": ("⇌", "⥫", "═", "⥬"),
  "\\xmapsto": ("↦", "├", "─", "→"),
}

const fontsByName* = {
  "\\mathrm": fNone,
  "\\mathit": fItalic,
  "\\mathbf": fBold,
  "\\mathcal": fScript,
  "\\mathfrak": fFraktur,
  "\\mathbb": fDoubleStruck,
}

const fontStarts* = [
  ltLatin: [
    fItalic: 119860,
    fBold: 119808,
    fScript: 119964,
    fFraktur: 120068,
    fDoubleStruck: 120120,
  ],
  ltGreek: [
    fItalic: 120546,
    fBold: 120488,
    fScript: 0,
    fFraktur: 0,
    fDoubleStruck: 0,
  ],
]

const fontExceptions* = [
  fItalic: @{rune"h": "ℎ"},
  fBold: @[],
  fScript: @{
    rune"B": "ℬ",
    rune"E": "ℰ",
    rune"F": "ℱ",
    rune"H": "ℋ",
    rune"I": "ℐ",
    rune"L": "ℒ",
    rune"M": "ℳ",
    rune"R": "ℛ",
    rune"e": "ℯ",
    rune"g": "ℊ",
    rune"o": "ℴ",
  },
  fFraktur: @{
    rune"C": "ℭ",
    rune"H": "ℌ",
    rune"I": "ℑ",
    rune"R": "ℜ",
    rune"Z": "ℨ",
  },
  fDoubleStruck: @{
    rune"C": "ℂ",
    rune"H": "ℍ",
    rune"N": "ℕ",
    rune"P": "ℙ",
    rune"Q": "ℚ",
    rune"R": "ℝ",
    rune"Z": "ℤ",
  },
]

func inFont*(letter: Rune, font: Font): string =
  if font == fNone:
    return $letter
  for (lhs, rhs) in fontExceptions[font]:
    if letter == lhs:
      return rhs
  let (typ, shift) = case letter
    of rune"A" .. rune"Z": (ltLatin, 65)
    of rune"a" .. rune"z": (ltLatin, 71)
    of rune"Α" .. rune"Ω": (ltGreek, 913)
    of rune"α" .. rune"ω": (ltGreek, 919)
    else: raise newException(ValueError, &"Invalid letter: {letter}")
  let fontStart = fontStarts[typ][font]
  if fontStart == 0:
    raise newException(ValueError, &"Letter {letter} can't be rendered in font {font}")
  return $Rune(fontStart + letter.ord - shift)

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
  "\\imath": "", "\\nabla": "∇", "\\Im": "ℑ", "\\Reals": "ℝ", "\\OE": "Œ",
  "\\jmath": "ȷ", "\\partial": "∂", "\\image": "ℑ", "\\wp": "℘", "\\o": "ø",
  "\\aleph": "ℵ", "\\Game": "⅁", "\\Bbbk": "k", "\\weierp": "℘", "\\O": "Ø",
  "\\alef": "ℵ", "\\Finv": "Ⅎ", "\\N": "ℕ", "\\Z": "ℤ", "\\ss": "ß",
  "\\alefsym": "ℵ", "\\cnums": "ℂ", "\\natnums": "ℕ", "\\aa": "å", "\\i": "ı",
  "\\beth": "ℶ", "\\Complex": "ℂ", "\\R": "ℝ", "\\AA": "Å", "\\j": "ȷ",
  "\\gimel": "ℷ", "\\ell": "ℓ", "\\Re": "ℜ", "\\ae": "æ",
  "\\daleth": "ℸ", "\\hbar": "ℏ", "\\real": "ℜ", "\\AE": "Æ",
  "\\eth": "ð", "\\hslash": "ℏ", "\\reals": "ℝ", "\\oe": "œ",
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
  rune"0": "⁰",
  rune"1": "¹",
  rune"2": "²",
  rune"3": "³",
  rune"4": "⁴",
  rune"5": "⁵",
  rune"6": "⁶",
  rune"7": "⁷",
  rune"8": "⁸",
  rune"9": "⁹",
  rune"+": "⁺",
  rune"−": "⁻",
  rune"=": "⁼",
  rune"(": "⁽",
  rune")": "⁾",
  rune"i": "ⁱ",
  rune"n": "ⁿ",
  rune" ": "",
}.toTable

const subscripts* = {
  rune"0": "₀",
  rune"1": "₁",
  rune"2": "₂",
  rune"3": "₃",
  rune"4": "₄",
  rune"5": "₅",
  rune"6": "₆",
  rune"7": "₇",
  rune"8": "₈",
  rune"9": "₉",
  rune"+": "₊",
  rune"-": "₋",
  rune"=": "₌",
  rune"(": "₍",
  rune")": "₎",
  rune"a": "ₐ",
  rune"e": "ₑ",
  rune"o": "ₒ",
  rune"x": "ₓ",
  rune"h": "ₕ",
  rune"k": "ₖ",
  rune"l": "ₗ",
  rune"m": "ₘ",
  rune"n": "ₙ",
  rune"p": "ₚ",
  rune"s": "ₛ",
  rune"t": "ₜ",
  rune"i": "ᵢ",
  rune"r": "ᵣ",
  rune"j": "ⱼ",
  rune"u": "ᵤ",
  rune"β": "ᵦ",
  rune"v": "ᵥ",
  rune"χ": "ᵪ",
  rune"γ": "ᵧ",
  rune"ρ": "ᵨ",
  rune"φ": "ᵩ",
  rune" ": "",
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
