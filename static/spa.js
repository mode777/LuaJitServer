var buffer = {}
var get = function(path,callback){
    if(!buffer[path])
        $.get(path, function(res){
            buffer[path] = res;
            callback(res);
        });
    else
        callback(buffer[path]);
}

spa = {
    templates: {},
    controllers: {},
    loadTemplate: function(path, callback){
        var that = this;
        if(that.templates[path])
            callback(that.templates[path])
        else
            get(path,function(str){
                var tmpl = doT.template(str);
                that.templates[path] = tmpl;
                callback(tmpl);
            });
    },
    loadScript: function(path,callback){
        $.ajaxSetup({
            cache: true
        });
        $.getScript( path ).done(callback).fail(function( jqxhr, settings, exception ) {
            throw(exception);
        });
    },
    route: function(path){
        var that = this;
        var parr = path.split("/");
        var controller = parr[0] || spa.config.defaultController,action = parr[1] || "index",args;
        args = parr.slice(2)
        //console.log("controller:"+controller+" action:"+action)
        //console.log(args)
        this.loadScript("/controllers/"+controller+".js",function(){
            that.controllers[controller][action](args);
        });
    },
    render: function(id,content,animate){
        if(animate){
            var that = this;
            that.animations.unload(id,function(){
                $("#"+id).html(content);
                that.animations.load(id);
            });
        }
        else
            $("#"+id).html(content);
    },
    renderView: function(controller,action,data){
        var that = this
        var tmplPath = "/views/"+controller+"/"+action+".tmpl.html"
        that.loadTemplate(tmplPath,function(tmpl){
            that.render("content",tmpl(data),true);
        });
    },
    animations: {
        unload: function(id, callback){
            $("#"+id).animate({opacity:0.0},500,callback);
        },
        load: function(id, callback) {
            $("#"+id).animate({opacity:1.0},500,callback);
        }
    }
}

var hashChanged = function(){
    var path = window.location.hash.substring(1).toLowerCase();
    spa.route(path);
}

$(function(){
    spa.loadTemplate("/templates/header.tmpl.html",function(tmpl){
        spa.render("header",tmpl(),false);
    });
    spa.loadTemplate("/templates/footer.tmpl.html",function(tmpl){
        spa.render("footer",tmpl(),false);
    });
    window.onhashchange = hashChanged;
    hashChanged();
});