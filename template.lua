_tmplPrint = nil

local htmlHelpers = require 'htmlHelpers'
local loadstring, concat, format, smt, pairs, setfenv = loadstring, table.concat, string.format, setmetatable, pairs, setfenv
local file = require "file"
local template = {}
function template.load(path, body)
    local file = file.retrieve(config.serverRoot..path, true)
    if not file then return end
    local result = {}
    local function parse(str)
        str = str.." "
        local pre, code, rest = str:match("(.-)<%?lua(.-)%?>(.+)")
        if str and not pre then result[#result+1] = format(" print([[%s]]) ",str) end
        if pre then result[#result+1] = format(" print([[%s]]) ",pre) end
        if code then result[#result+1] = code end
        --if rest then print("Rest: "..rest) end
        if rest then parse(rest) end
    end
    parse(file.data)
    local st = concat(result)

    local func = assert(loadstring(st))

    return function(data)
        local result = {}
        data = data or {}
        _tmplPrint = function(...)
            local args = {... }
            for _,v in ipairs(args) do
                result[#result+1] = tostring(v)
            end
        end
        data.print = _tmplPrint
        data.Helpers = htmlHelpers
        local layout
        data.UseLayout = function(path)
            layout = path
        end
        data.RenderBody = function()
            result[#result+1] = body
        end
        smt(data,{__index = _G})
        setfenv(func,data)
        local _,err =  pcall(func)
        if not err then
            if not layout then
                return concat(result)
            else
                return template.load(layout,concat(result))(data)
            end
        else
            return "Error rendering "..path..": "..err
        end
    end
end
return template