local url = require "socket.url"
local helpers = require 'helpers'
local match, type = string.match, type
local httpHelpers = {}

function httpHelpers.parseQueryString(str)
    local t = {}
    local getter = helpers.split(str,"&")
    if(type(getter) == "string")then
        local key, value = str:match("(.-)=(.+)")
        t[key] = url.unescape(value)
    else
        for str in getter do
            local key, value = str:match("(.-)=(.+)")
            t[key] = url.unescape(value)
        end
    end
    return t
end

function httpHelpers.parseURL(request)
    local parsed = url.parse(request.url)
    request.scheme = parsed.scheme
    request.rawPath = parsed.path
    request.path = url.parse_path(parsed.path)
    request.query = parsed.query and httpHelpers.parseQueryString(parsed.query) or {}
    request.fragment = parsed.fragment
    request.host = parsed.host
    request.port = parsed.port
    if #request.path > 0 then
        request.extension = match(request.path[#request.path], "%.([^%.]+)$")
    end
end
return httpHelpers