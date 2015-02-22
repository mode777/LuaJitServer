io.output():setvbuf("no")
local http = require "http"
local cs = require "coroutineSheduler"
local server = http.createServer("*",80)
server.run()
cs.run()
