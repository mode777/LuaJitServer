spa = {
    templates:{},
    navigateTo: function(content){
        window.location.hash = "#"+content.toLowerCase();
    },
    loadTemplate: function(path, callback){
        var that = this;
        if(this.templates[path]){
            callback(this.templates[path]);
        }
        else{
            $.get(path,function(result){
                var tmpl = doT.template(result)
                that.templates[path] = tmpl;
                callback(tmpl);
            });
        }
    }
}


var hashChanged = function(){
    $( "#content" ).animate({
        opacity: 0.0,
    }, 500, function() {
        spa.currentView  = window.location.hash.substring(1);
        spa.loadTemplate(spa.currentView+".tmpl.html",function(tmpl){
            $("#content").html(tmpl());
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
    window.location.hash= window.location.hash=="" ? "#content/home" : window.location.hash
    window.onhashchange = function() {
        hashChanged();
    }
    spa.currentView  = window.location.hash.substring(1).toLowerCase();
    spa.navigateTo(spa.currentView);
    hashChanged();
});