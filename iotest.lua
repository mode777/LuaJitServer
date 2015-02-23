local data = [[
    return {
        longitude=104.533025,
        about="Laboris anim sit qui duis cupidatat reprehenderit tempor ex nostrud officia enim officia sint voluptate. Ex mollit enim consectetur ullamco enim eiusmod magna. Ipsum qui exercitation ex magna exercitation cillum tempor officia aliquip sit dolore.\r\n",
        _id="54ea27de3dc1f3e53430c4a1",
        company="NAMEGEN",
        picture="http=//placehold.it/32x32",
        registered="2014-11-30T02=14=36 -01=00",
        tags={
            "dolor",
            "laborum",
            "eu",
            "duis",
            "ut",
            "minim",
            "Lorem"
        },
        favoriteFruit="banana",
        greeting="Hello, Annie Webster! You have 10 unread messages.",
        friends={
            {
                name="Carpenter Goodman",
                id=0
            },{
                name="Chapman Hartman",
                id=1
            },{
                name="Petersen Gay",
                id=2
            }
        }
    }
]]

--local path = [[/root/LuaJitServer/iotest]]
local path = [[E:\users\Alex\Dropbox\code\Web\server\iotest]]

local t = os.clock()
for i=0, 1000 do
    local file,err = io.open(path.."/"..i..".lua","w")
    if err then error(err) end
    file:write(data)
    file:close()
end
print("Files written in "..os.clock()-t)
local t = os.clock()
local data = {}

for i=0, 1000 do
    data[#data+1] = loadfile(path.."/"..i..".lua")()
end
print(#data,"Tables read")
print("Files read and evaluated in "..os.clock()-t)
