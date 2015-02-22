local coroutines = {}
local cm = {}
local items = {}

cm.add = function(func)
    local cr = coroutine.create(func)
    coroutines[cr] = true
end
cm.update = function()
    items = 0
    for cr,_ in pairs(coroutines) do
        local s = coroutine.status(cr)
        if s == "dead" then
            coroutines[cr] = nil
        else
            --print("resume",cr)
            assert(coroutine.resume(cr))
        end
        items = items+1
    end
end

cm.info = function()
    return "Active threads: "..items
end

cm.run = function()
    while 1 do
        cm.update()
    end
end

return cm