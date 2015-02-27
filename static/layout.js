spa = {
    navigateTo: function(content){
        window.location.hash = "#"+content
    }
}

var hashChanged = function(){
    $( "#content" ).animate({
        opacity: 0.0,
    }, 500, function() {
        spa.currentView  = window.location.hash.substring(1);
            $.get("/content/"+spa.currentView+".tmpl.html",function(result){
                $("#content").html(result);
                $("#content").animate({
                    opacity:1.0
                },500);
            });
    });
}

$(function(){
    $.get("/templates/header.tmpl.html",function(result){
        $("#header").html(result);
    });
    $.get("/templates/footer.tmpl.html",function(result){
            $("#footer").html(result);
    });
    window.location.hash= window.location.hash=="" ? "#home" : window.location.hash
    window.onhashchange = function() {
        hashChanged();
    }
    spa.currentView  = window.location.hash.substring(1);
    spa.navigateTo(spa.currentView);
    hashChanged();
});