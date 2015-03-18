io.output():setvbuf("no")
--todo: precompile templates
--todo: proper coockie parsing
--todo: post requests
config = require "conf"
local http = require "http"
controller = require "controller"
app = {}
require "app"
app.start()
local cs = require "coroutineSheduler"
local server = http.createServer("*",80)
server.run()
cs.run()