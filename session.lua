local uuid = require 'uuid'
uuid.seed()
local sessions = {}

local session = {}
function session.create(response)
    --print("Created session")
    local sessionId = uuid()
    response.fields["Set-Cookie"] = config.appIdentity.."="..sessionId.."; Path=/;"
    sessions[sessionId] = {}
    return sessions[sessionId], sessionId
end
function session.resume(sessionId)
    --if not sessions[sessionId] then print("session not found") else print("session found") end
    return sessions[sessionId]
end
function session.destroy(sessionId)
    if sessions[sessionId] then
        sessions[sessionId] = nil
    end
end
return session