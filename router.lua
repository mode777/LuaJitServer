local url = require 'socket.url'
local routes = require 'routes'
local data = require 'data'


return function(request, response)
    if routes[request.path] then return routes[request.path](request,response)
    else
        local parsed = url.parse_path(request.path)
        if parsed[1] == "api" then
            local ret = data.base
            for i=2, #parsed do
                local key = tonumber(parsed[i]) and tonumber(parsed[i]) or parsed[i]
                if ret[key] then
                    ret = ret[key]
                else
                    response.statusCode = 404
                end
            end
            response.content = data.toJSON(ret)
            response.fields["Content-Type"] = "application/json"
            response.fields["Content-Length"] = response.content:len()
            --print(response.content)
        else
        if parsed[2] == "log" then

        end
            return routes["*"](request,response)
        end
    end
end