# Package

version       = "2022.7.20"
author        = "Adam Blažek"
description   = "Render LaTeX math as multiline Unicode text"
license       = "GPL-3.0-or-later"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["matext"]


# Dependencies

requires "nim >= 1.6.0"

requires "cligen >= 1.5.21"
requires "honeycomb >= 0.1.2"


# Tasks

task mjs, "Compile to JavaScript to be used in the playground":
  exec "nimble js -d:release --out:site/matext.js src/matext.nim"
  echo "Minifying with terser"
  exec "terser site/matext.js -o site/matext.min.js --compress --mangle --module"
  echo "Done"
