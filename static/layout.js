$(function(){
    $.get("/templates/header.tmpl.html",function(result){
        $("#header").html(result);
    });
    $.get("/templates/footer.tmpl.html",function(result){
            $("#footer").html(result);
    });
});