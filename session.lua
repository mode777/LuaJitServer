local uuid = require 'uuid'
uuid.seed()
local sessions = {}

local session = {}
function session.create(response)
    local sessionId = uuid()
    response.fields["Set-Cookie"] = config.appIdentity.."="..sessionId.."; Path=/;"
    sessions[sessionId] = {}
    return sessions[sessionId]
end
function session.resume(sessionId)
    return sessions[sessionId]
end
function session.destroy(sessionId)
    sessions[sessionId] = nil
end
return session