import jester

import std/[
  strutils,
  os
]

router mainrouter:
  get "/favicon.ico":     
    sendFile("./static/favicon.ico")
  get "/js/script.js":
    resp readFile("./static/js/script.js"), "text/javascript;charset=utf-8"

  get "/css/@filename":
    cond @"filename" in ["style.css", "index.css", "about.css"]

    resp readFile("./static/css/" & @"filename"), "text/css;charset=utf-8"
  
  get "/about":
    sendFile("./public/about.html")

  get "/coffee":
    resp Http418

when isMainModule:
  for dir in ["static", "public"]:
    for file in walkDir(dir):
      setFilePermissions(file.path, getFilePermissions(file.path) + {fpOthersRead})

  var server = initJester(
    mainrouter, 
    newSettings(port = Port(getEnv("PORT").parseInt))
  )

  server.serve()