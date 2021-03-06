local helpers = {}
function helpers.split(self, pat)
    --if not self:find(pat) then return self end
    local st, g = 1, self:gmatch("()("..pat..")")
    local function getter(self, segs, seps, sep, cap1, ...)
        st = sep and seps + #sep
        return self:sub(segs, (seps or 0) - 1), cap1 or sep, ...
    end
    local function splitter(self)
        if st then return getter(self, st, g()) end
    end
    return splitter, self
end

return helpers