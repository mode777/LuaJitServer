Options.alex = "blex"

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
            title="Home",
            heading="Welcome to the Lua Server",
            username = Session and Session.username or ""
        })
    end
}

function Controller.login()
    local data = {
        title="Login",
        heading = "Login to Web App"
    }
    if Request.method == "GET" then
        return Result.view(data)
    elseif Request.method == "POST" then
        if Request.form["login"] == "Alex" and Request.form["password"] == "famicom" then
            CreateSession()
            Session["username"] = "Alexander Klingenbeck"
            Session.authorized = true
            --return Result.view("Login success.")
            return Result.redirect("/home","Login success")
        else
            data.message = "Username or password incorrect."
            return Result.view(data)
        end
    end
end

function Controller.logout()
    if Session then
        local usr = Session.username
        DestroySession()
        --return Result.plainText(usr.." was logged out.")
    end
    return Result.redirect("/home/login")
end

Controller.about = {
    authorize = true,
    callback = function()
        return Result.view({title="About"})
    end
}

Controller.contact = {
    authorize = true,
    callback = function()
        return Result.view({title="Contact"})
    end
}
