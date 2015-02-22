local conf = require 'conf'
local staticFileHandler = require 'routers.staticFiles'

return {
    ["/"] = function(request, response)
        request.path = conf.defaultPath or "/"
        staticFileHandler(request,response)
    end,
    --["api/<path>"] = require('routers.appihandler'),
    ["*"] = staticFileHandler
}