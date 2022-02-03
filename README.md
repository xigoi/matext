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
       n
╭    1╮
│1 + ─│
╰    n╯

$ matext << END
\left(1 + \frac{1}{n}\right)^n
END
       n
╭    1╮
│1 + ─│
╰    n╯
```

### Nim library

```nim
import matext
let latex = "\\left(1 + \\frac{1}{n}\\right)^n"
echo latex.matext
#        n
# ╭    1╮
# │1 + ─│
# ╰    n╯
```
