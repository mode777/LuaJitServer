local goip = {}
local http = require 'socket.http'
local cr = require 'coroutineSheduler'

local function wait(s)
    local stime = socket.gettime()*1000;
    while (socket.gettime()*1000-stime < s) do
        coroutine.yield()
    end
end

local function updateIp(username, password)
    local ip = http.request('http://api.ipify.org')
    http.request('http://api.ipify.org')
    local request = [[http://www.goip.de/setip?username=]]..username..[[&password=]]..password..[[&subdomain=]]..username..[[.goip.de&ip=]]..ip..[[&html=false]]
    local answer = http.request(request)
    print(answer);
end

function goip.run(username, password, interval)
    print(username,password,interval)
    interval = interval or 60
    while true do
        updateIp(username,password,interval)
        wait(interval)
    end
end

goip.run(arg[1], arg[2], arg[3])
cr.run()