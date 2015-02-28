spa.controllers.portfolio = {
    index: function(){
        spa.loadDataAsync("/data/galleries.json",function(data){
            spa.renderView(data);
        });
    },
    gallery: function(name){
        spa.loadDataAsync("/data/galleries/"+name+".json",function(data){
            spa.renderView(data);
        });
    }
}
spa.controllers.info = {
    index: function(){
        spa.renderView();
    }
}
spa.controllers.contact = {
    index: function(){
        spa.renderView();
    }
}

spa.controllers.test = {
    index: function(){
        spa.renderView();
    }
}
