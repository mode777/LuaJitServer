local url = require 'socket.url'
--local routes = require 'routes'
local data = require 'data'
local file = require 'file'

return function(request, response)
    local parsed = url.parse_path(request.path)
    -- Is file request?
    if #parsed > 0 and string.match(parsed[#parsed], "%.([^%.]+)$") then
        local file = file.retrieve(config.staticFilePath..request.path, config.disableCaching)
        if file then
            response.content = file.data
            response.fields["Content-Type"] = file.mimeType
            if file.download then response.fields["Content-Disposition"] = string.format("attachment; filename=\"%s\"",file.filename) end
        else
            response.statusCode = 404
        end
    elseif #parsed > 0 then
        local controller = table.remove(parsed,1) or "home"
        local action = table.remove(parsed,1) or "index"
        controller = controller:lower()
        action = action:lower()
        if controllers[controller] then
            if controllers[controller][action] then
                controllers[controller](action,request,response,unpack(parsed))
            else
                response.content = "Action "..action.." was not found in Controller "..controller.."."
            end
        else
            response.content = "Controller "..controller.." was not found."
        end
    else
        controllers.home("index",request,response)
    end
end
