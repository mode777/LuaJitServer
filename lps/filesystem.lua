io.output():setvbuf("no")
local bit = require 'bit'
local ffi = require("ffi")
ffi.cdef[[
typedef struct {
    uint32_t address, size, uuid[4];
    bool occupied;
} addressEntry;
]]
require 'socket'
local uuid = require 'uuid'
uuid.seed()
local mask = 0x000000FF

local bytes = {}
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
        res = res + str:byte(i)
    end
    return res
end

local function setBit(number, offset)
    offset = offset or 0
    return bit.bor(number,bit.lshift(1,offset))
end

local function clearBit(number, offset)
    offset = offset or 0
    return bit.band(number,bit.bnot(bit.lshift(1,offset)));
end

local function checkBit(number, offset)
    offset = offset or 0
    return bit.band(bit.rshift(number, offset), 1) == 1 and true or false
end

local HEXES = '0123456789abcdef'
local function uuidToInteger(uid)
    uid = string.gsub(uid,"-","")
    local numbers = ffi.new("uint32_t[4]")
    for i=0, 3 do
        numbers[i] = 0
        for j=0, 8 do
            numbers[i] = numbers[i] * 16
            local index = i*8+j
            local char = string.char(uid:byte(index))
            numbers[i] = numbers[i] + HEXES:find(char)-1
        end
    end
    return numbers
end

local function integerToUuid(integer)
    local strings = {bit.tohex(integer[0]),bit.tohex(integer[1]),bit.tohex(integer[2]),bit.tohex(integer[3]) }
    local guid = table.concat(strings)
    return string.format("%s-%s-%s-%s-%s",guid:sub(1,8),guid:sub(9,12),guid:sub(13,16),guid:sub(17,20),guid:sub(21,32))
end

local function filesystem(filename, size)
    local interface = {}
    local addresses
    local uuidLookup = {}
    local handle
    addresses = ffi.new("addressEntry[?]", size)
    local f,err = io.open(filename,"rb")
    -- Read addresses.
    if not err then
        local total = 0
        for i=0, size-1 do
            addresses[i].address = readInt(f)
            addresses[i].size = readInt(f)
            addresses[i].occupied = checkBit(addresses[i].size)
            if addresses[i].size ~= 0 then
                addresses[i].size = bit.rshift(addresses[i].size,1)
                addresses[i].uuid[0] = readInt(f)
                addresses[i].uuid[1] = readInt(f)
                addresses[i].uuid[2] = readInt(f)
                addresses[i].uuid[3] = readInt(f)
                local uuid = integerToUuid(addresses[i].uuid)
                uuidLookup[uuid] = i
                --print(string.format("Address: %s, Size: %s, Occupied: %s, UUID: %s",addresses[i].address,addresses[i].size,tostring(addresses[i].occupied),integerToUuid(addresses[i].uuid)))
            else
                total = i;
                break;
            end

        end
        f:close()
        print("Loaded file:"..filename.." capacity:"..size.." read entries:"..total)
    else
        f,err = io.open(filename,"wb");
        f:seek("set",size*24-4)
        writeInt(f,0);
        f:close()
        print("Created file:"..filename.." capacity:"..size)
    end
    function interface:open()
        handle = io.open(filename,"rb+");
    end
    function interface:close()
        handle:close()
        handle = nil
    end
    function interface:writeEntry(index)
        --print(index)
        handle:seek("set",(index*24))
        writeInt(handle,addresses[index].address)
        local size32 = bit.lshift(addresses[index].size,1)
        if(addresses[index].occupied) then
            size32 = setBit(size32)
        end
        writeInt(handle,size32)
        writeInt(handle,addresses[index].uuid[0])
        writeInt(handle,addresses[index].uuid[1])
        writeInt(handle,addresses[index].uuid[2])
        writeInt(handle,addresses[index].uuid[3])
    end
    function interface:findAddress(address)
        for i=0, #addresses do
            if addresses[i].address == address then
                return i
            end
        end
        return -1
    end
    function interface:findUuid(uid)
        return uuidLookup[uid] or -1
    end
    function interface:markEmpty(address)
        local index = self:findAddress(address)
        if index ~= -1 then
            addresses[index].occupied = false
            addresses[index].uuid = ffi.new("uint32_t[4]")
        end
        self:open()
        self:writeEntry(index)
        self:close()
    end
    function interface:newEntry(uuid, size)
        local uuidInt = uuidToInteger(uuid)
        local ctr = 0
        local space = 0
        local smallest
        local smallestIndex = 0
        while(addresses[ctr].size ~= 0) do
            local free = not addresses[ctr].occupied
            local cspace = addresses[ctr].size
            if free then
                if cspace >= size then
                    if not smallest then
                        smallest = cspace
                        smallestIndex = ctr
                    end
                    if smallest > cspace then
                        smallest = cspace
                        smallestIndex = ctr
                    end
                end
            end
            space = space + cspace
            ctr = ctr+1
        end
        --new entry
        if not smallest then
            --print("Appending a new entry.")
            addresses[ctr].address = space
            addresses[ctr].size = size
            addresses[ctr].occupied = true
            addresses[ctr].uuid = uuidInt
            uuidLookup[uuid] = ctr
            self:writeEntry(ctr)
            return ctr
            --smallest entry
        elseif smallest == size then
            print("Found a perfect match.")
            addresses[smallestIndex].occupied = true
            addresses[smallestIndex].uuid = uuidInt
            uuidLookup[uuid] = smallestIndex
            self:writeEntry(smallestIndex)
            return smallestIndex
            --else
        elseif smallest > size then
            print("Have to split.")
            addresses[ctr].address = addresses[smallestIndex].address + size
            addresses[ctr].size = addresses[smallestIndex].size - size
            addresses[smallestIndex].occupied = true
            addresses[smallestIndex].uuid = uuidInt
            uuidLookup[uuid] = smallestIndex
            self:writeEntry(ctr)
            self:writeEntry(smallestIndex)
            return addresses[smallestIndex].address
        else
            error("Something went wrong.")
        end
    end
    return interface
end

local t = os.clock()
local fs = filesystem("test.bin",1000000);
fs.open()
for i=1, 200000 do
    fs:newEntry(uuid(),math.random(1000));
end
fs.close()
print("Time:", os.clock()-t)

--local uid = uuid()
--local intArr = uuidToInteger(uid)
--local uidStr = integerToUuid(intArr)


--addrTable:loadOrCreate("test.bin",1000000)
--addrTable:newEntry(50)
--for i=0, 10 do
--    print("Number "..i)
--    local adr = addresses[i]
--    print("Address: "..adr.address)
--    print("Size: "..bit.rshift(adr.size,1))
--    print("Free: "..tostring(not checkBit(adr.size)))
--    print("-------")
--end
--print("Time:", os.clock()-t)
