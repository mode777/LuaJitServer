local json = require "json"
local file = require "file"
local template = require "template"

local result = {}

result.staticFile = function(path)
    return function(controllerName,action,request,response)
        local file = file.retrieve(config.staticFilePath..request.path, config.disableCaching)
        if file then
            response.content = file.data
            response.fields["Content-Type"] = file.mimeType
            if file.download then response.fields["Content-Disposition"] = string.format("attachment; filename=\"%s\"",file.filename) end
        else
            response.statusCode = 404
        end
    end
end

result.plainText = function(text)
    text = tostring(text)
    return function(controllerName,action,reqest,response)
        response.content = text
        response.fields["Content-Type"] = "text/plain"
    end
end

result.html = function(html)
    return function(controllerName,action,reqest,response)
        response.content = html
        response.fields["Content-Type"] = "text/html"
    end
end

result.json = function(tab)
    local jsonString = json.encode(tab)
    return function(controllerName,action,reqest,response)
        response.content = jsonString
        response.fields["Content-Type"] = "application/json"
    end
end

local codes = {
    [200] = "OK",
    [405] = "Method not allowed",
    [404] = "Not found",
    [500] = "Internal server error",
    [307] = "Temporary redirect"
}
result.statusCode =function(code, message)
    code = code or 200
    message = message or codes[code] or ""
    return function(controllerName,action,reqest,response)
        response.statusCode = code
        response.statusMessage = message
    end
end

result.redirect = function(path,message)
    path = path or "/"
    message = message or codes[307]
    return function(controllerName,action,reqest,response)
        response.statusCode = 307
        response.statusMessage = message
        response.fields.location = path
    end
end

result.view = function(data)
    -- if not table or has numeric indices (is array/mixed)
    if type(data) ~= "table" or (type(data) == "table" and #data > 0) then data = {data=data} end

    return function(controllerName,action,reqest,response)
        local path = "/views/"..controllerName.."/"..action..".lsp"
        local template = template.load(path)
        if template then
            result.html(template(data))(controllerName,action,reqest,response)
        else
            result.statusCode(404,"No view for action "..action)(controllerName,action,reqest,response)
        end
    end
end

return result