io.output():setvbuf("no")
local bit = require 'bit'
local bytes = {}
local mask = 0x000000FF

local function writeInt(handle, num)
    for i=1,4 do
        local shift = (4-i)*8
        bytes[i] = bit.band(bit.rshift(num,shift),mask)
    end
    handle:write(string.char(bytes[1],bytes[2],bytes[3],bytes[4]));
end

local function readInt(handle)
    local str = handle:read(4)
    local res = 0
    for i=1,4 do
        res = bit.lshift(res,8)
        --print(str:len())
        res = res + str:byte(i)
    end
    return res
end
local t = os.clock()
local f = io.open("test.bin","w")
for i=1, 500000 do
    writeInt(f,i)
    writeInt(f,0x00000001)
end
f:close()
print("Writing data:", os.clock()-t)
t = os.clock()
local f = io.open("test.bin","rb")
for i=1, 1000000 do
    readInt(f)
end
print("Reading data:", os.clock()-t)
