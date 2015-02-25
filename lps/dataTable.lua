local uuid = require 'uuid'
uuid.seed()
local data = require 'data'

local helpers = {}

function helpers.stringifyKey(key)
    local t = type(key)
    if t == "string" then
        return string.format("[\"%s\"]",key)
    elseif t == "number" then
        return tostring("[\"%d\"]",key)
    elseif t == "table" then
        error("Tables cannot be keys.")
    else
        error("Unsupported format: "..t)
    end
end

function helpers.stringifyTable(t)
    local concat = {"{"}
    local _isArr, _keys
    _keys = 0
    for i,v in pairs(t) do
        _keys = _keys+1
    end
    _isArr = _keys == #t and true or false
    if _isArr then
        for i=1,#t do
            concat[#concat+1] = string.format("%s,",helpers.stringifyValue(t[i]))
        end
    else
        for k,v in pairs(t) do
            concat[#concat+1] = string.format("%s=%s,",helpers.stringifyKey(k),helpers.stringifyValue(v))
        end
    end
    concat[#concat+1] = "}"
    return table.concat(concat)
end

function helpers.stringifyValue(val)
    local t = type(val)
    if t == "string" then
        return string.format("\"%s\"",val)
    elseif t == "number" then
        return tostring(val)
    elseif t == "table" then
        if not val.isDataTable then
            return helpers.stringifyTable(val)
        else
            return string.format("{ _guid=\"%s\" }",val.getGuid())
        end
    else
        error("Unsupported format: "..t)
    end
end

local dataTable = {}

function dataTable.wrap(t)
    local proxy = {}
    local _guid
    if t._guid then
        _guid, t._guid = t._guid, nil
    else
        _guid = uuid()
    end

    function proxy.getGuid()
        return _guid
    end

    function proxy.makeRoot()
        _guid = "root"
        return proxy
    end
    --local _isResolved
    --function proxy.isResolved()
    --    return
    --end

    local _isArr, _keys, _isEmpty
    _keys = 0
    for i,v in pairs(t) do
        _keys = _keys+1
    end
    if _keys == 0 then
        _isEmpty = true
    else
        _isArr = _keys == #t and true or false
    end

    function proxy.isArray()
        return _isArr;
    end

    function proxy.isEmpty()
        return _isEmpty;
    end

    function proxy.forEach(func)
        if _isArr then
            for i=1, #t do func(i,t[i]) end
        else
            for i,v in pairs(t) do func(i,v) end
        end
    end

    function proxy.serialize()
        local concat = {"return {" }
        if _isArr then
            proxy.forEach(function(i,v)
                concat[#concat+1] = string.format("%s,",helpers.stringifyValue(v))
            end)
        else
            proxy.forEach(function(k,v)
                concat[#concat+1] = string.format("%s=%s,",helpers.stringifyKey(k),helpers.stringifyValue(v))
            end)
        end
        concat[#concat+1] = "}"
        return table.concat(concat)
    end

    function proxy.save()
        local file = io.open(data.directory.._guid..".lua","w")
        file:write(proxy.serialize())
        file:close()
        return proxy
    end
    proxy.isDataTable = true;
    setmetatable(proxy,{__index=t, __newindex=function(_,k,v) t[k] = v end})
    return proxy
end

return dataTable








