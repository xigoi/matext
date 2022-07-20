import matextpkg/render

# JavaScript module
when defined(js):
  import std/jsffi
  proc matext*(latex: cstring, opts: JsObject): cstring {.exportc.} =
    var opts = opts
    if opts == jsUndefined:
      opts = newJsObject()
    render($latex, oneLine = opts.oneLine.to(bool)).cstring
  {.emit: "export default matext;".}

# Command-line application
elif isMainModule:
  import cligen
  proc matext(args: seq[string], oneLine = false): string =
    try:
      for arg in args:
        stdout.writeLine arg.render(oneLine = oneLine)
      if args.len == 0:
        stdout.writeLine stdin.readAll.render(oneLine = oneLine)
    except ValueError:
      stderr.writeLine "matext: error: " & getCurrentExceptionMsg()
  dispatch matext, short = {"oneLine": '1'}, help = {
    "oneLine": "force the output to be on one line by mangling vertical notation"
  }

# Nim library
else:
  proc matext*(latex: string, oneLine = false): string =
    latex.render(oneLine = oneLine)
