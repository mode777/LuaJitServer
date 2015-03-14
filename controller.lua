local file = require "file"
local template = require "template"
local session = require "session"

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


local codes = {
    [200] = "OK",
    [405] = "Method not allowed",
    [404] = "Not found",
    [500] = "Internal server error."
}
result.statusCode =function(code, message)
    code = code or 200
    message = message or codes[code] or ""
    return function(controllerName,action,reqest,response)
        response.statusCode = code
        response.statusMessage = message
    end
end

--local myTemplate = template.load("/views/home/index.lsp")

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

controllers = {}

return function(name)
    if not name then error("Controller needs a name.") end
    local controller = {}
    setmetatable(controller, {
        __call = function(t,action,request,response,...)
            if(t[action])then
                local env
                local current_session = request.sessionId and session.resume(request.sessionId) or nil
                env = {
                    session = current_session,
                    createSession = function()
                        if current_session then
                            session.destroy(request.sessionId)
                        end
                        env.session = session.create(response)
                    end,
                    destroySession = function()
                        session.destroy(request.sessionId)
                        env.session = nil
                    end,
                    request=request,
                    response=response,
                    result=result,
                }
                setmetatable(env,{__index=_G})
                setfenv(t[action],env)
                local actionResult = t[action](...)
                if not actionResult then
                    result.statusCode(200)(name,action,request,response)
                else
                    actionResult(name,action,request,response)
                end
            end
        end
    })
    controllers[name] = controller
    return controller
end