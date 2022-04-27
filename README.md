# maTeXt

A program and Nim library for rendering LaTeX math as multiline Unicode text

[![builds.sr.ht status](https://builds.sr.ht/~xigoi/matext.svg)](https://builds.sr.ht/~xigoi/matext?)

## Installation

### From source

```sh
git clone https://git.sr.ht/~xigoi/matext
cd matext
nimble install
```

## Usage

### CLI

Simply invoke `matext` and give it LaTeX math, either on STDIN or in a command line argument:

```
$ matext '\left(1 + \frac{1}{n}\right)^n'
       𝑛
⎛    1⎞
⎜1 + ─⎟
⎝    𝑛⎠

$ matext << END
\left(1 + \frac{1}{n}\right)^n
END
       𝑛
⎛    1⎞
⎜1 + ─⎟
⎝    𝑛⎠
```

### Nim library

```nim
import matext
let latex = "\\left(1 + \\frac{1}{n}\\right)^n"
echo latex.matext
#        𝑛
# ⎛    1⎞
# ⎜1 + ─⎟
# ⎝    𝑛⎠
```

## Supported features

The goal is to mostly match [KaTeX's list of supported functions](https://katex.org/docs/supported.html). Features which are not planned to be supported are marked with a cross.

- ☑ digits, English letters
- ☐ accents
- ☐ delimiters
  - ☑ \left \right
  - ☒ \big, etc.
- ☐ environments
  - ☐ array, matrix
  - ☐ cases
  - ☐ equation, align, gather
  - ☐ CD
- ☑ Greek and other letters
- ☐ fonts
- ☐ layout
  - ☐ \cancel, \sout
  - ☐ \tag
  - ☐ \overbrace, \underbrace
  - ☐ \not
  - ☐ \boxed
- ☐ line breaks
- ☐ vertical layout
  - ☑ superscript, subscript
  - ☐ \stackrel, \overset, \underset, \atop
- ☐ spaces
- ☐ macros
- ☐ operators
  - ☐ big operators
  - ☑ binary operators
  - ☑ logic & set theory
  - ☑ fractions
  - ☐ binomials
  - ☑ text operators
  - ☑ square root
    - ☐ n-th square root
  - ☑ relations
  - ☐ negated relations
  - ☐ arrows
    - ☐ extensible arrows
  - ☐ bra-ket
- ☒ color
- ☒ font size
- ☐ display style
- ☐ text mode
  - ☐ punctuation
- ☒ units
