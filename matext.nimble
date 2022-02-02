# Package

version       = "2022.2.2"
author        = "Adam Blažek"
description   = "Render LaTeX math as multiline Unicode text"
license       = "GPL-3.0-or-later"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["matext"]


# Dependencies

requires "nim >= 1.6.0"

requires "cligen >= 1.5.21"
requires "honeycomb >= 0.1.1"
