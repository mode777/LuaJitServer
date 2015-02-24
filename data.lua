
local json = require 'json'
local conf = require 'conf'
local io = io

local data = {}

data.base = {}

function data.toJSON(t)
    return json.encode(t)
end

function data.fromJSON(str)
    return json.decode(str)
end

function data.storeDatabase()
    local file,err = io.open (conf.dataLocation.."/".."dataBase.json","w")
    if not err then
        file:write(data.toJSON(data.base))
        file:close()
    end
end

function data.loadDatabase()
    local file,err = io.open (conf.dataLocation.."/".."dataBase.json","r")
    if not err then
        local d = file:read("*a")
        file:close()
        data.base = data.fromJSON(d)
    else
        error(err)
    end
end
local t = os.clock()
--data.loadDatabase()
print("Database loaded, "..os.clock()-t)
return data

