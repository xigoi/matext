import cligen
import matextpkg/render

when isMainModule:
  proc matext(args: seq[string]): string =
    for arg in args:
      echo arg.render
    if args.len == 0:
      echo stdin.readAll.render
  dispatch matext
else:
  proc matext*(latex: string): string =
    latex.render
