--local path = ""
--local lfs = require 'lfs'
--print(lfs.currentdir())
--print("test")

local mastertable = {}

local a,b,c,d = {"a"},{"b"},{"c"},{"d"}

mastertable[a]=true
mastertable[b]=true
mastertable[c]=true
mastertable[d]=true

local testlist = {a,b,c,d,{"e"} }

local metameta = {}
setmetatable(metameta,{__index=function(t,i) return {"notfound"} end})

local meta = {}
setmetatable(meta, {__index=metameta})
meta._secretKey = "I'm a secret"

setmetatable(testlist,{__mode='v',__index=meta})

mastertable[a] = nil
a = nil
collectgarbage()

for i=1, #testlist do
    print(testlist[i][1])
end
print(testlist._secretKey)



