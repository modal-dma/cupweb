<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="../js/constants.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Prestazioni</title>

<!-- CSS Files -->
<link type="text/css" href="../css/base.css" rel="stylesheet" />
<link type="text/css" href="../css/Icicle.css" rel="stylesheet" />

<!--[if IE]><script language="javascript" type="text/javascript" src="../../Extras/excanvas.js"></script><![endif]-->

<!-- JIT Library File -->
<script language="javascript" type="text/javascript" src="../js/jit.js"></script>

<!-- Example File -->
<script language="javascript" type="text/javascript" src="../js/sunburst.js"></script>

  </head>

  <body>  
     <%@include file="headerPrestazioni.jsp" %>
           
    <script>
   
      
      function refresh()
      {
    	  showLoader();
    	  
    	  var prestazione = $('#prestazioni').val();
  		  var gender = $('#gender').find(":selected").attr("value");
          var userLimit = $('#userLimit').val();
          var anni = $('#anni').find(":selected").attr("value");
          var annoPartenza = $('#annoPartenza').find(":selected").attr("value");
          var eta = $('#eta').find(":selected").attr("value");
          			
          var url = serverUrl + "/modal/api/1.0.0/pathPrestazioniNelTempo?"

              	
          url += "prestazione=" + prestazione;
          url += "&gender=" + gender;
          url += "&limitUser=" + userLimit;
          url += "&startdate=" + annoPartenza;
          url += "&anni=" + anni;
          if(eta != "tutti")
          	url += "&eta=" + eta;
      	
      	$.ajax({
    	    type: "GET",
    		url: url,
    		async: true,
    		error: function(e) {
    			//error({'error': e});
    			hideLoader();
    		    alert("Impossibile comunicare con il servizio " + e);
    		},
    		success: function( model ) {
    			hideLoader();
    			
    			var json = {
    					"id": 1, 
    					"name": model.name,
    				     "data": {
    				      "size": model.count,
    				      "$type": "none",
    				      "$color": "#910E8F",
    				      "children": 0
    				    }, 
    				    "children": []
    			};
    			
    			populateJSON(json, model.children, 1);
    			json.data.children = json.children.length;
    			
    			$('#infovis').css("height", $(window).height() + "px");
    			$('#infovis').html("");
    			initSunburst(json);    			    			
    		}
    	});      	      	      				      
      }                 
      var id = 1;
      
      
      function populateJSON(node, children, level)
      {    	   
    	  var count = 0;
    	  for(var i = 0; i < children.length; i++)
    	  {    		
    		  var child = children[i];
  
    		  if(child.count > 18 / Math.pow(level, 2))
    		  {    			   
	    	  	  var nodeChild = {
						"id": "id:" + level + "-" + (++id), 
						"name": child.name,
					     "data": {
					      "$angularWidth": child.count,
					      "size": child.count,
					      "$color": getColor(level),
					      "children": 0
					    },
					    "children": []
					};
	    	  	  
	    	  	  
	    	  		node.children.push(nodeChild);
	    	  		
	    	  	  	populateJSON(nodeChild, child.children, level + 1);    	  	     	  	  
	    	  	  	nodeChild.data.children = nodeChild.children.length;    	  	  
	    	  	  
    		  }
    	  }    	  	        	  
      }
      
      function numHex(num)
      {
    	  var s = parseInt(num, 10)
          var a = s.toString(16);
          if ((a.length % 2) > 0) {
              a = "0" + a;
          }
          return a;
      }
      
      function getColor(i)
      {
     	var frequency = 1;
     	var amplitude = 127;
     	var center = 128;
     	var phase = 128;
     		
 		var red   = Math.cos(frequency*i+1) * amplitude + center;
 	    var green = Math.cos(frequency*i+2) * amplitude + center;
 	    var blue  = Math.cos(frequency*i+3) * amplitude + center;
 		    
 	    return '#' + numHex(red) + numHex(green) + numHex(blue);
 	    
 		//return 'rgba(' + red + ', ' + green+ ', ' + blue + ', 0.2)';
    		
      }
      
    </script>
  	<div id="container" style="margin-top: 10px">
			<div id="center-container">
    			<div id="infovis"></div>    
			</div>
		</div>
		
		<script>
		$('#infovis').css("height", ($(window).height() - $('#branche').height() - 20) + "px");
				
		</script>
  </body>
</html>
