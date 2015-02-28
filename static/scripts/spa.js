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
    models: {},
    loadTemplateAsync: function(path, callback){
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
    loadScriptAsync: function(path,callback){
        $.ajax({
          url: path,
          dataType: "script",
          cache:true,
          success: callback,
          error: function(e,f,g){ throw("Error in " + path + " Error:" + g) },
        });
    },
    loadDataAsync: function(path,callback){
        $.ajax({
          url: path,
          dataType: "json",
          cache:true,
          success: callback,
          error: function(e,f,g){ throw("Error in " + path + " Error:" + g) },
        });
    },
    route: function(path){
        var that = this;
        var parr = path.split("/");
        var controller = parr[0] || spa.config.defaultController,action = parr[1] || "index",args;
        args = parr.slice(2)
        //console.log("controller:"+controller+" action:"+action)
        //console.log(args)
        this.currentController = controller;
        this.currentAction = action;
        if(that.controllers[controller])
            that.controllers[controller][action].apply(this,args);
        else
            that.renderView("error","404",{path:path});
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
    renderView: function(controller, action, data){
        if(arguments.length<=1){
            data = arguments[0] || "";
            controller = this.currentController;
            action = this.currentAction || "index";
        }
        var that = this;
        var tmplPath = "/views/"+controller+"/"+action+".tmpl.html";
        console.log(tmplPath);
        that.loadTemplateAsync(tmplPath,function(tmpl){
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
    },
    loadScriptsAsync: function(arr,callback){
        arr.forEach(function(v,i){
            spa.loadScriptAsync(v,function(res){
                console.log(v)
                if(i==arr.length-1)
                    callback(res);
            });
        });
    },
}

var hashChanged = function(){
    var path = window.location.hash.substring(1).toLowerCase();
    spa.route(path);
}

$(function(){
    spa.loadTemplateAsync("/templates/header.tmpl.html",function(tmpl){
        spa.render("header",tmpl(),false);
    });
    spa.loadTemplateAsync("/templates/footer.tmpl.html",function(tmpl){
        spa.render("footer",tmpl(),false);
    });
    window.onhashchange = hashChanged;
    hashChanged();
});