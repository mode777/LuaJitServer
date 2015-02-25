local uuid = require 'uuid'
uuid.seed()
local data = require 'data'

local function stringifyKey(key)
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

local function stringifyValue(val)
    local t = type(val)
    if t == "string" then
        return string.format("\"%s\"",val)
    elseif t == "number" then
        return tostring(val)
    elseif t == "table" then
        if not val.getGuid then
            error("Only dataTables can be serialized. Call wrapData first.")
        else
            return string.format("{ _guid=\"%s\" }", val.getGuid()), t
        end
    else
        error("Unsupported format: "..t)
    end
end

local function wrapData(t)
    local proxy = {}
    if t._guid then
        proxy._guid, t._guid = t._guid, nil
    else
        proxy._guid = uuid()
    end
    setmetatable(proxy,{__index=t})

    function proxy.getGuid()
        return proxy._guid
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
                concat[#concat+1] = string.format("%s,",stringifyValue(v))
            end)
        else
            proxy.forEach(function(k,v)
                concat[#concat+1] = string.format("%s=%s,",stringifyKey(k),stringifyValue(v))
            end)
        end
        concat[#concat+1] = "}"
        return table.concat(concat)
    end

    function proxy.save()
        local file = io.open(data.directory..proxy._guid..".lua","w")
        file:write(proxy.serialize())
        file:close()
    end

    proxy.save()
    return proxy
end

local myData = wrapData({
    lieblingsschnubbi =  "Marion",
    alter = 29,
    lieblingstier = "Berti",
    hobbies = wrapData({"computer","malen","programmieren"})
})




