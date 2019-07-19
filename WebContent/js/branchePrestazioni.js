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


function createTreemap(json){
  //init TreeMap
  var tm = new $jit.TM.Squarified({
    //where to inject the visualization
    injectInto: 'infovis',
    //parent box title heights
    titleHeight: 15,
    //enable animations
    animate: false,//animate,
    //box offsets
    offset: 1,
    //Attach left and right click events
    Events: {
      enable: true,
      onClick: function(node) {
        if(node) tm.enter(node);
      },
      onRightClick: function() {
        tm.out();
      }
    },
    duration: 1000,
    //Enable tips
    Tips: {
      enable: true,
      //add positioning offsets
      offsetX: 20,
      offsetY: 20,
      //implement the onShow method to
      //add content to the tooltip when a node
      //is hovered
      onShow: function(tip, node, isLeaf, domElement) {
    	  
        var html;
        var data = node.data;
        
        if(data.level == 1)
        {
        	html = "<div class=\"tip-title\" style='font-size: 18px;'>" + node.name 
    		+ "</div><div class=\"tip-text\">";
        }
        else
        {        	        
        	html = "<div class=\"tip-title\">" + node.name 
        		+ "</div><div class=\"tip-text\">";
        }
        
        if(data.playcount > 1) {
          html += "play count: " + data.playcount.toFixed(0) + "%";
        }
        else {
            html += "play count: " + data.playcount.toFixed(2) + "%";
          }
        if(data.image) {
          html += "<img src=\""+ data.image +"\" class=\"album\" />";
        }
        tip.innerHTML =  html; 
      }  
    },
    //Add the name of the node in the correponding label
    //This method is called once, on label creation.
    onCreateLabel: function(domElement, node){
        domElement.innerHTML = node.name;
        var style = domElement.style;
        style.display = '';
        style.border = '1px solid transparent';
        style.cursor = 'hand';
        style.textAlign = 'center';
        style.verticalAlign = 'middle';

        domElement.onmouseover = function() {
          style.border = '1px solid #9FD4FF';
        };
        domElement.onmouseout = function() {
          style.border = '1px solid transparent';
        };
    },
    onPlaceLabel: function(domElement, node) 
    {
        var style = domElement.style;
        var fontSize;
        if(node.data.level == 2)
        {   
        	fontSize = (Math.sqrt((domElement.clientWidth * domElement.clientHeight)/50));
    		//var area = node.data.$area;
    		
    		//style.fontSize = "8px"
    		//style.fontSize = (Math.sqrt(parseInt(area))) + 'px';
    		
    		
        }
        else if(node.data.level == 1)
        {        	
        	fontSize = "10px;";//(Math.sqrt((domElement.clientWidth * domElement.clientHeight)/400));
    		//var area = node.data.$area;
    		
    		//style.fontSize = "8px"
    		//style.fontSize = (Math.sqrt(parseInt(area))) + 'px';
    		//style.fontSize = (Math.sqrt((domElement.clientWidth * domElement.clientHeight)/400)) + 'px';
        }       
        
        style.fontSize = fontSize + 'px';
        
        
   }
  });
  tm.loadJSON(json);
  tm.refresh();
  //end
 
}
