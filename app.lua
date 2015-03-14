function app.start()
    local home = controller("home")
    function home.index(...)
        return result.view({
            myData={
                {text="Home",href="/home/"},
                {text="Content",href="/content/"},
                {text="Index",href="/index/" }
            },
            title="Lua Server",
            heading="Welcome to the Lua Server",
            username = session and session.username or ""
        })
    end
    function home.add(...)
        local numbers = {...}
        local res = 0
        for i=1, #numbers do
            res = res + tonumber(numbers[i]) or 0
        end
        return result.plainText(res)
    end
    function home.login(username)
        if username then
            createSession()
            session.username = username
            return result.view(username)
        end
    end
    function home.logout()
        if session then
            local usr = session.username
            destroySession()
            return result.plainText(usr.." was logged out.")
        end
    end

    local test = controller("test")
    function test.index(id)
        return result.plainText(id)
    end

    function test.json()
        return result.json(request)
    end
end