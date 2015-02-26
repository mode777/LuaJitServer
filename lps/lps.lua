local data = require 'dataTable'
local generateContent = require 'content_generator'

local root = generateContent()
data.wrap(root).makeRoot().save();



