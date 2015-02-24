local goip = {}
local http = require 'socket.http'
local cr = require 'coroutineSheduler'

local function wait(s)
    local t = os.clock()
    while (os.clock()-t < s) do
        coroutine.yield()
    end
end

local function updateIp(username, password)
    local ip = http.request('http://api.ipify.org')
    http.request('http://api.ipify.org')
    local request = [[http://www.goip.de/setip?username=]]..username..[[&password=]]..password..[[&subdomain=]]..username..[[.goip.de&ip=]]..ip..[[&html=false]]
    local answer = http.request(request)
    print(answer)
end

function goip.run(username, password, interval)
    print(username,password,interval)
    interval = tonumber(interval) or 60
    while true do
        updateIp(username,password,interval)
        wait(interval)
    end
end

local usr, pwd, ival = arg[1], arg[2], arg[3]
goip.run(usr,pwd,ival)
cr.run()