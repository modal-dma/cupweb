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
//    if (!this.elem) 
//      this.elem = document.getElementById('log');
//    this.elem.innerHTML = text;
//    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
  }
};


function init_hypertree(json){
    //init data
    var infovis = document.getElementById('infovis');
    var w = infovis.offsetWidth - 50, h = infovis.offsetHeight - 50;
    
    //init Hypertree
    var ht = new $jit.Hypertree({
      //id of the visualization container
      injectInto: 'infovis',
      //canvas width and height
      width: w,
      height: h,
      levelsToShow: 10,
      //Change node and edge styles such as
      //color, width and dimensions.
      Node: {
          dim: 9,
          color: "#f00",
          'overridable': true 	  
      },
      Edge: {
          lineWidth: 2,
          color: "#088",
          'overridable': true
      },
      //zooming by scrolling and panning.
      Navigation: {
        enable: true,
        panning: true,
        zooming: 3
      },
      Tips: {  
          enable: true,  
          type: 'Native',  
          offsetX: 10,  
          offsetY: 10,  
          onShow: function(tip, node) {  
          	
        	  //"<br/><b>Percentage: </b> " + (100 * node.data.count / node.data.parent.data.count) + "</div>" +
        	  tip.innerHTML = 
          	    "<div class=\"tip-title\"><b>" + node.name + "</b></div>" + 
            		"<div class=\"tip-text\"><b>" +
            			 "<b>Occurences: </b> " + node.data.count + "<br/>" +
            			 "<b>Percentage: </b> " + node.data.percentage.toFixed(2) + "<br/>" +
            				"Min: " + node.data.min + "<br/>" +
            				"Max: " + node.data.max + "<br/>" +
            				"Average: " + node.data.average + "<br/>" +
            				"Children: " + node.data.children + 
            		"</div>";         	               
          }  
        },  
      onBeforeCompute: function(node){
          Log.write("centering");
      },
      onBeforePlotLine: function(adj){
      	adj.data.$lineWidth = adj.nodeTo.data.percentage + 1;
          //Set random lineWidth for edges.  
//          if (!adj.data.$lineWidth)   
//              adj.data.$lineWidth = Math.random() * 7 + 1;  
      },  
      //Attach event handlers and add text to the
      //labels. This method is only triggered on label
      //creation
      onCreateLabel: function(domElement, node){
          domElement.innerHTML = node.name;
          $jit.util.addEvent(domElement, 'click', function () {
              ht.onClick(node.id, {
                  onComplete: function() {
                      ht.controller.onComplete();
                  }
              });
          });
      },
      //Change node styles when labels are placed
      //or moved.
      onPlaceLabel: function(domElement, node){
          var style = domElement.style;
          style.display = '';
          style.cursor = 'pointer';
          if (node._depth <= 1) {
              style.fontSize = "0.8em";
              style.color = "#ddd";

          } else if(node._depth == 2){
              style.fontSize = "0.7em";
              style.color = "#555";

          } else {
              style.display = 'none';
          }

          var left = parseInt(style.left);
          var w = domElement.offsetWidth;
          style.left = (left - w / 2) + 'px';
      },
      
      onComplete: function(){
          Log.write("done");
          
          //Build the right column relations list.
          //This is done by collecting the information (stored in the data property) 
          //for all the nodes adjacent to the centered node.
          var node = ht.graph.getClosestNodeToOrigin("current");
          var html = "<h4>" + node.name + "</h4><b>Connections:</b>";
          html += "<ul>";
          node.eachAdjacency(function(adj){
              var child = adj.nodeTo;
              if (child.data) {
                  var rel = (child.data.band == node.name) ? child.data.relation : node.data.relation;
                  html += "<li>" + child.name + " " + "<div class=\"relation\">(relation: " + rel + ")</div></li>";
              }
          });
          html += "</ul>";
          $jit.id('inner-details').innerHTML = html;
      }
    });
    //load JSON data.
    ht.loadJSON(json);
    //compute positions and plot.
    ht.refresh();
    //end
    ht.controller.onComplete();
}
