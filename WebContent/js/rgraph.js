var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
  elem: false,
  write: function(text){
    if (!this.elem) 
      this.elem = document.getElementById('log');
    this.elem.innerHTML = text;
    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};


function init_rgraph(json) {
    
    //init RGraph
    var rgraph = new $jit.RGraph({
        //Where to append the visualization
        injectInto: 'infovis',
        //Optional: create a background canvas that plots
        //concentric circles.
        background: {
          CanvasStyles: {
            strokeStyle: '#555'
          }
        },
        //Add navigation capabilities:
        //zooming by scrolling and panning.
        Navigation: {
          enable: true,
          panning: true,
          zooming: 3
        },
        //Set Node and Edge styles.
        Node: {
            color: '#ddeeff',
            'overridable': true, 
        },
        
        Edge: {
          color: '#C17878',
          lineWidth:1.5,
          'overridable': true, 
        },
        Tips: {  
            enable: true,  
            type: 'Native',  
            offsetX: 10,  
            offsetY: 10,  
            onShow: function(tip, node) {  
            	
              tip.innerHTML = 
            	    "<div class=\"tip-title\"><b>Occurences: </b> " + node.data.count + "</div>" +
              		"<div class=\"tip-text\"><b>" +
              				"Min: " + node.data.min + "<br/>" +
              				"Max: " + node.data.max + "<br/>" +
              				"Average: " + node.data.average + "<br/>" +
              				"Children: " + node.data.children + 
              		"</b></div>";            	               
            }  
          },  
//        onShow: function(tip, node){
//            // count children
//            var count = 0;
//            node.eachSubnode(function(){
//              count++;
//            });
//            // add tooltip info
//            tip.innerHTML = "<div class=\"tip-title\"><b>Name:</b> " + node.name
//                + "</div><div class=\"tip-text\">" + count + " children<br/>" + node.data.$area + " occurrences </div>";
//          },
        onBeforeCompute: function(node){
        	 
        	 
        	 
            //Log.write("centering " + node.name + "...");
            //Add the relation list in the right column.
            //This list is taken from the data property of each JSON node.
            //$jit.id('inner-details').innerHTML = node.data.relation;
        },
        
        onBeforePlotLine: function(adj){
        	adj.data.$lineWidth = adj.nodeTo.data.count / 10 + 1;
            //Set random lineWidth for edges.  
//            if (!adj.data.$lineWidth)   
//                adj.data.$lineWidth = Math.random() * 7 + 1;  
        },  
        
        //Add the name of the node in the correponding label
        //and a click handler to move the graph.
        //This method is called once, on label creation.
        onCreateLabel: function(domElement, node){
            domElement.innerHTML = node.name;
            domElement.onclick = function(){
                rgraph.onClick(node.id, {
                    onComplete: function() {
                        //Log.write("done");
                    }
                });
            };
        },
        //Change some label dom properties.
        //This method is called each time a label is plotted.
        onPlaceLabel: function(domElement, node){
            var style = domElement.style;
            style.display = '';
            style.cursor = 'pointer';

            if (node._depth <= 1) {
                style.fontSize = "0.8em";
                style.color = "#ddd";
            
            } else if(node._depth == 2){
                style.fontSize = "0.7em";
                style.color = "#ccc";
            
            } else {
            	style.fontSize = "0.7em";
                style.color = "#ccc";
                //style.display = 'none';
            }

            var left = parseInt(style.left);
            var w = domElement.offsetWidth;
            style.left = (left - w / 2) + 'px';
        }
    });
    //load JSON data
    rgraph.loadJSON(json);
    //trigger small animation
    rgraph.graph.eachNode(function(n) {
      var pos = n.getPos();
      pos.setc(-200, -200);
    });
    rgraph.compute('end');
    rgraph.fx.animate({
      modes:['polar'],
      duration: 2000
    });
    //end
    //append information about the root relations in the right column
    //$jit.id('inner-details').innerHTML = rgraph.graph.getNode(rgraph.root).data.relation;
}
