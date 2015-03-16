io.output():setvbuf("no")
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
    function home.login()
        if request.method == "GET" then
            return result.view()
        elseif request.method == "POST" then
            if request.form["login"] == "Alex" and request.form["password"] == "famicom" then
                print("Login success")
                createSession()
                session["username"] = "Alexander Klingenbeck"
                return result.redirect("/home","Login success")
            else
                return result.view("Username or password incorrect.")
            end
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

    function test.post()
        if request.form then
            return result.json(request.form)
        else
            return result.statusCode("404","Post data not found.")
        end
    end

    function test.get()
        if request.query then
            return result.json(request.query)
        else
            return result.statusCode("404","Query data not found.")
        end
    end
end