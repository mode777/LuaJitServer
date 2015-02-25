local conf = require 'conf'
local mime = require 'mime'
local time = require 'time'
local url = require 'socket.url'
local log = require 'log'

local io = io

local function readFile(path, mode)

    local file,err = io.open (path,mode)
    if not err then
        local data, size
        if mode == "r" then
            data = file:read('*a')
            size = data:len()
        else
            size = file:seek("end")
            file:seek("set")
            data = file:read(size)
        end
        file:close()
        --print(path,mode,size,data:len())
        log(size.." bytes cached ("..path..").")
        return data, size
    end
end

local function newFile(path)
    local f = {}
    local segments = url.parse_path(path)
    if segments.is_directory then
        return false
    else
        local filename = segments[#segments]
        local _, ext = filename:match("(.-)%.(.+)")
        local mimeType = mime[ext] or mime["*"]
        local mode = mimeType.read == "binary" and "rb" or "r"
        local data, size = readFile(conf.staticFilePath..path,mode)
        if data then
            f.data = data
            f.size = size
            f.mimeType = mimeType.type
            f.path = path
            f.lastLoaded = time.new()
            f.lastAccess = time.new()
            f.mode = mode
            f.download = mimeType.download
            f.filename = filename
        else
            return false
        end
    end

    function f.reload()
        f.data, f.size = readFile(conf.staticFilePath..f.path,f.mode)
        f.lastLoaded = time.new()
    end

    return f
end

local cache = {}
local cacheFiles = {}
local cacheFilesByPath = {}

cache.size = 0

function cache.clear()
    cacheFiles = {}
    cacheFilesByPath = {}
end

function cache.clean()
    table.sort(cacheFiles,function(f1,f2) return f1.lastAccess.totalSeconds < f2.lastAcess.totalSeconds end)
    local remTable = {}
    local i = 1
    while cache.size > conf.cacheSize do
        cache.size = cacheFiles[i].size
        i = i + 1
        remTable[#remTable+1] = i
        --remove indexed references
        cacheFilesByPath[cacheFiles[i].path] = nil
    end
    for _,v in ipairs(remTable) do
        --remove array references
        table.remove(cacheFiles[v])
    end
end

function cache.store(file)
    cacheFiles[#cacheFiles+1] = file
    cacheFilesByPath[file.path] = file
    cache.size = cache.size + file.size
    if cache.size > conf.cacheSize then
        cache.clean()
    end
end

function cache.retrieve(path, reload)
    local file = cacheFilesByPath[path]
    if not file then
        file = newFile(path)
        if file then cache.store(file) end
    end
    if file then
        if reload then file.reload() end
        file.lastAccess = time.new()
    end
    return file
end

return cache