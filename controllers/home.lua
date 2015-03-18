Controller.index = {
    allowed = {"GET"},
    authorize = true,
    redirect = "/home/login",
    callback = function(...)
        return Result.view({
            myData={
                {text="Home",href="/home/"},
                {text="Content",href="/content/"},
                {text="Index",href="/index/" }
            },
            title="Lua Server",
            heading="Welcome to the Lua Server",
            username = Session and Session.username or ""
        })
    end
}

function Controller.login()
    if Request.method == "GET" then
        return Result.view()
    elseif Request.method == "POST" then
        if Request.form["login"] == "Alex" and Request.form["password"] == "famicom" then
            print("Login success")
            CreateSession()
            Session["username"] = "Alexander Klingenbeck"
            Session.authorized = true
            --return Result.view("Login success.")
            return Result.redirect("/home","Login success")
        else
            return Result.view("Username or password incorrect.")
        end
    end
end

function Controller.logout()
    if Session then
        local usr = Session.username
        DestroySession()
        return Result.plainText(usr.." was logged out.")
    end
end
