local items = {
    {
        title= "This is my title",
        desc = "This is my description",
        done = false
    },
}

function Controller.index()
    return Result.view({items=items})
end

