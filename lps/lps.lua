local data = require 'dataTable'
local generateContent = require 'content_generator'

local root = {}
generateContent(root)

data.wrap(root).makeRoot().save();



