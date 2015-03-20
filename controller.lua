local session = require "session"
local result = require 'results'

local controllers = {}

Controller = function(name)
    if not name then error("Controller needs a name.") end
    local controller = {}
    controller._options = {}
    setmetatable(controller, {
        __call = function(t,action,request,response,...)
            if(t[action])then
                local env
                local current_session = request.sessionId and session.resume(request.sessionId) or nil
                request.session = current_session
                local authorized = current_session and current_session.authorized or false

                if(not t[action].authorize or (t[action].authorize and authorized)) then
                    env = {
                        Session = current_session,
                        CreateSession = function()
                            if request.sessionId then
                                session.destroy(request.sessionId)
                            end
                            local id
                            env.Session, id = session.create(response)

                        end,
                        DestroySession = function()
                            session.destroy(request.sessionId)
                            env.session = nil
                        end,
                        Request=request,
                        Response=response,
                        Result=result,

                    }
                    setmetatable(env,{__index=_G})
                    setfenv(t[action].callback,env)
                    local actionResult = t[action].callback(...)
                    if not actionResult then
                        result.statusCode(200)(name,action,request,response)
                    else
                        actionResult(name,action,request,response)
                    end
                else
                    print(t[action].redirect)
                    result.redirect(t[action].redirect or "/", "Authorization required")(name,action,request,response)
                end
            end
        end,
        __newindex = function(t,key,val)
            if type(val) == "function" then
                val = {callback=val}
            end
            rawset(t,key,val)
        end
    })
    controllers[name] = controller
    return controller
end

function InvokeController(request, response, ...)
    if controllers[request.controller] then
        if controllers[request.controller][request.action] then
            controllers[request.controller](request.action,request,response,...)
        else
            response.content = "Action "..request.action.." was not found in Controller "..request.controller.."."
        end
    else
        response.content = "Controller "..request.controller.." was not found."
    end
end

--load controllers
local lfs = require 'lfs'
local path = config.serverRoot.."/controllers"
local _, err = lfs.chdir(path)
if err then error(err) end
for file in lfs.dir(path) do
    if file ~= "." and file ~= ".." then
        local name = file:match("(.-).lua")
        local contr = loadfile(file)
        local controller = Controller(name);
        local env = {
            Controller = controller,
            Options = controller._options
        }
        setmetatable(env, {__index=_G})
        setfenv(contr, env)
        contr()
    end
end
local _, err = lfs.chdir(config.serverRoot)