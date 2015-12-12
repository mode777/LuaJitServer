local goip = {}
local http = require 'socket.http'

local function wait(s)
    --linux only
    os.execute("sleep "..s)
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
