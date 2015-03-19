local json = require 'json'

local helpers = {}

function helpers.json(tab)
    local str = json.encode(tab)
    _tmplPrint(str)
end

return helpers

