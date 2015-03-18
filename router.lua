--local routes = require 'routes'
local data = require 'data'
local file = require 'file'
local string,table = string,table

return function(request, response)
    -- Is file request?
    if request.extension then
        local file = file.retrieve(config.staticFilePath..request.rawPath, config.disableCaching)
        if file then
            response.content = file.data
            response.fields["Content-Type"] = file.mimeType
            if file.download then response.fields["Content-Disposition"] = string.format("attachment; filename=\"%s\"",file.filename) end
        else
            response.statusCode = 404
        end
    else
        request.controller = table.remove(request.path,1) or "home"
        request.action = table.remove(request.path,1) or "index"
        request.controller = request.controller:lower()
        request.action = request.action:lower()
        local args = {}
        for _,v in ipairs(request.path) do args[#args+1] = v end
        for _,v in pairs(request.query) do args[#args+1] = v end
        for _,v in pairs(request.form) do args[#args+1] = v end
        InvokeController(request,response,unpack(args))
        --controllers.home("index",request,response)
    end
end
