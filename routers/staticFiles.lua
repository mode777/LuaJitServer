local file = require 'file'
local conf = require 'conf'

return function(request, response)
    local file = file.retrieve(request.path, conf.disableCaching)
        if file then
	        response.content = file.data
	        response.fields["Content-Type"] = file.mimeType
	        response.fields["Content-Length"] = file.size
	        if file.download then response.fields["Content-Disposition"] = string.format("attachment; filename=\"%s\"",file.filename) end
	    else
        response.statusCode = 404
    end
end
