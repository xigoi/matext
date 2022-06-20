import matextpkg/render

when isMainModule:
  import cligen
  proc matext(args: seq[string]): string =
    try:
      for arg in args:
        stdout.writeLine arg.render
      if args.len == 0:
        stdout.writeLine stdin.readAll.render
    except ValueError:
      stderr.writeLine "matext: error: " & getCurrentExceptionMsg()
  dispatch matext
elif defined(js):
  proc matext*(latex: cstring): cstring {.exportc.} =
    latex.render
  {.emit: "export default matext;".}
else:
  proc matext*(latex: string): string =
    latex.render
