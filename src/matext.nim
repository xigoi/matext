import cligen
import matextpkg/render

when isMainModule:
  proc matext(args: seq[string]): string =
    try:
      for arg in args:
        stdout.writeLine arg.render
      if args.len == 0:
        stdout.writeLine stdin.readAll.render
    except ValueError:
      stderr.writeLine "matext: error: " & getCurrentExceptionMsg()
  dispatch matext
else:
  proc matext*(latex: string): string =
    latex.render
