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
    ["*"] = {
        type = "application/force-download",
        read = "binary",
        download = true
    }

}

--aliases
types.jpg = types.jpeg

return types