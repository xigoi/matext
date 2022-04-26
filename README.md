# maTeXt

A program and Nim library for rendering LaTeX math as multiline Unicode text

## Installation

### From source

```sh
git clone https://github.com/xigoi/matext/
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

## Currently supported features

The goal is to match [KaTeX's list of supported functions](https://katex.org/docs/supported.html).

- [x] digits, English letters
- [ ] accents
- [ ] delimiters
  - [x] \left \right
  - [ ] \big, etc.
- [ ] environments
  - [ ] array, matrix
  - [ ] cases
  - [ ] equation, align, gather
  - [ ] CD
- [ ] Greek and other letters
- [ ] fonts
- [ ] layout
  - [ ] \cancel, \sout
  - [ ] \tag
  - [ ] \overbrace, \underbrace
  - [ ] \not
  - [ ] \boxed
- [ ] vertical layout
  - [x] superscript, subscript
  - [ ] \stackrel, \overset, \underset, \atop
- [ ] spaces
- [ ] logic & set theory
- [ ] macros
- [ ] operators
  - [ ] big operators
  - [x] binary operators
  - [x] fractions
  - [ ] binomials
  - [x] text operators
  - [x] square root
    - [ ] n-th square root
  - [x] relations
  - [ ] negated relations
  - [ ] arrows
    - [ ] extensible arrows
  - [ ] bra-ket
- [ ] text mode
  - [ ] punctuation
