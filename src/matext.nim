import matextpkg/render
import std/strutils

# Nim library
when not isMainModule:
  proc matext*(latex: string, oneLine = false): string =
    latex.render(oneLine = oneLine)

# JavaScript module
when defined(js):
  import std/jsffi
  proc matextJs(latex: cstring, opts: JsObject): cstring {.exportc: "matext".} =
    var opts = opts
    if opts == jsUndefined:
      opts = newJsObject()
    render($latex, oneLine = opts.oneLine.to(bool)).cstring
  {.emit: "export default matext;".}

# Command-line application
elif isMainModule:
  import cligen
  proc matext(args: seq[string], oneLine = false, suppressNewline = false) =
    try:
      if args.len == 0:
        stdout.write stdin.readAll.render(oneLine = oneLine)
      else:
        stdout.write args.join(" ").render(oneLine = oneLine)
      if not suppressNewline:
        stdout.writeLine ""
    except ValueError:
      stderr.writeLine "matext: error: " & getCurrentExceptionMsg()
  dispatch matext, short = {"one-line": '1', "suppress-newline": 'n'}, help = {
    "one-line": "force the output to be on one line by mangling vertical notation",
    "suppress-newline": "don't add a trailing newline",
  }
