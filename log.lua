local time = require("time")
local conf = require("conf")

local file = io.open(conf.staticFilePath.."/log.txt","w");
file:close();
return function(msg)
    local enc = string.format("%s: %s \r\n", time.new().httpTime(),msg)
    local file = io.open(conf.staticFilePath.."/log.txt","a");
    file:write(enc)
    file:close()
    print(msg)
end