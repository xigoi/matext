import matextpkg/render

when defined(js):
  proc matext*(latex: cstring): cstring {.exportc.} =
    render($latex)
  {.emit: "export default matext;".}
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
else:
  proc matext*(latex: string): string =
    latex.render
