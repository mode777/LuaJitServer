local socket = require 'socket'
local url = require 'socket.url'
local cs = require 'coroutineSheduler'
local conf = require 'conf'
local router = require 'router'
local min = math.min
--local log = require 'log'

local http = {}

http.codes = {
    [200] = "OK",
    [405] = "Method not allowed",
    [404] = "Not found"
}
function http.createServer(host,port)
    local s = {}
    function s.run()
        local f = function()
            local server = socket.tcp()
            server:bind(host,port)
            server:listen(10000)
            server:settimeout(0)
            print("Server running: "..host..":"..port)
            while true do
                local sockClient = server:accept()
                if sockClient then
                    local client = http.createClient(sockClient)
                    client.run()
                end
                coroutine.yield()
            end
        end
        cs.add(f)
    end
    return s
end

function http.createClient(sockClient)
    local c = {}
    c.startTime = os.clock()
    function c.parseRequest()
        local request = {
            fields = {}
        }
        sockClient:settimeout(0)
        local res,err = nil, "timeout"
        while res ~= "" do
            res, err = sockClient:receive('*l')
            while err == "timeout" do
                res, err = sockClient:receive('*l')
                --if res then log(res) end
                coroutine.yield()
            end
            if(res) then
                --Parse request line
                if not request.method then
                    local method, path, version = res:match("(%w-) ([^%s]-) HTTP/(%d.%d)")
                    request.method, request.path, request.httpVersion, request.requestLine = method, path, version, res
                elseif res == "" then
                    request.finished = true
                --Parse header fields
                else
                    local key, value = res:match("(.-): (.+)")
                    if key then
                        key, value = key:lower(), value:lower()
                        if key == "cookie" then
                            request.sessionId = value:match(config.appIdentity.."=([^;]+)")
                        end
                        request.fields[key] = value
                    end
                end
            end
            if(err == "closed") then break end
        end
        return request
    end

    function c.handleResponse(request)
        local response = {
            statusCode = 200,
            fields = {
                ["Content-Type"] = "text/html",
                ["Content-Length"] = 0
            },
            content = ""
        }
        if request.method == "GET" then
            router(request,response)
        else
            response.statusCode = 405
        end
        return response
    end

    function c.writeResponse(response)
        local rt = {}
        --Write response line
        rt[#rt+1] = string.format("HTTP/1.1 %d %s\r\n", response.statusCode, response.statusMessage or http.codes[response.statusCode] or "")
        if response.content then
            response.fields["Content-Length"] = response.content:len()
        end
        for key,value in pairs(response.fields) do
            rt[#rt+1] = string.format("%s: %s\r\n", key, value)
        end
        rt[#rt+1] = "\r\n"
        sockClient:settimeout(1)
        --write response header
        --sockClient:send(table.concat(rt))
        if response.content then rt[#rt+1] = response.content end
        local respData = table.concat(rt)
        local c = respData:len()
        local i = 0
        local blocksize = 1024
        while i <= c do
            --local t = os.clock()
            local index, err = sockClient:send(respData,i+1,min(i+blocksize,c))
            if not err then
                i = i+blocksize
            else
                if err == "timeout" then
                    sockClient:close()
		            break
                elseif err == "closed" then
                    sockClient:close()
		            break
                end
            end
            coroutine.yield()
        end
        --print("Transfer finished. Timeout errors:"..to.." Max block:"..block)
    end
    --this is the client main loop
    function c.run()
        local f = function()
            while os.clock() - c.startTime < config.keepAliveTimeout do
                c.request = c.parseRequest()
                if c.request.finished then
                    c.response = c.handleResponse(c.request)
                    c.writeResponse(c.response)
                    print(c.request.requestLine)
                    if c.request.fields.connection ~= "keep-alive" then
                        sockClient:close()
                        break
                    end
                else
                    --print("Connection closed by client")
                    sockClient:close()
                    break
                end
            end
        end
        cs.add(f)
    end
    return c
end

return http
