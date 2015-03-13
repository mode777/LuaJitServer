io.output():setvbuf("no")
--todo: precompile templates
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
