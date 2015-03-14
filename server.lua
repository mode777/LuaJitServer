io.output():setvbuf("no")
--todo: precompile templates
--todo: proper coockie parsing
--todo: post requests
config = require "conf"
controller = require "controller"
app = {}
require "app"
app.start()
local http = require "http"
local cs = require "coroutineSheduler"
local server = http.createServer("*",80)
server.run()
cs.run()
