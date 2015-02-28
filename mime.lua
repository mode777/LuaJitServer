local types = {
    ico = {
        type = "image/x-icon",
        read = "binary"
    },
    html = {
        type = "text/html",
        read = "text"
    },
    jpeg = {
        type = "image/jpeg",
        read = "binary"
    },
    png = {
        type = "image/png",
        read = "binary"
    },
    gif = {
        type = "image/gif",
        read = "binary"
    },
    js = {
        type = "application/javascript",
        read = "text"
    },
    json = {
        type = "text/json",
        read = "text"
    },
    css = {
        type = "text/css",
        read = "text"
    },
    txt = {
        type = "text/plain",
        read = "text"
    },
    ["*"] = {
        type = "application/force-download",
        read = "binary",
        download = true
    }

}

--aliases
types.jpg = types.jpeg
types["min.js"] = types.js
types["min.css"] = types.css
types["tmpl.html"] = types.html
return types