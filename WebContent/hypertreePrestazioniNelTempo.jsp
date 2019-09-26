<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Prestazioni</title>

<!-- CSS Files -->
<link type="text/css" href="css/base.css" rel="stylesheet" />
<link type="text/css" href="css/Icicle.css" rel="stylesheet" />

<!--[if IE]><script language="javascript" type="text/javascript" src="../../Extras/excanvas.js"></script><![endif]-->

<!-- JIT Library File -->
<script language="javascript" type="text/javascript" src="js/jit.js"></script>

<!-- Example File -->
<script language="javascript" type="text/javascript" src="js/hypertree.js"></script>

  </head>

  <body>  
      <select id="prestazioni" name="groupid" style="width:20%;">
    	</select>
    	 <select id="gender" name="gender" style="width:100px;">    
      <option value='0'>Tutti</option>
      <option value='1'>Maschio</option>
      <option value='2'>Femmina</option>
      </select>
       <select id="annoPartenza" name="annoPartenza" style="width:100px;">    
      <option value='2014'>2014</option>
      <option value='2015'>2015</option>
      <option value='2016'>2016</option>
      <option value='2017'>2017</option>
      <option value='2018'>2018</option>
      <option value='2019'>2019</option>
      </select>
      <select id="anni" name="anni" style="width:100px;">         
      <option value='1'>1</option>
      <option value='2'>2</option>
      <option value='3'>3</option>
      <option value='4'>4</option>
      <option value='5'>5</option>
      </select>
      <select id="eta" name="eta" style="width:100px;">         
      <option value='0-14'>0-14</option>
      <option value='15-30'>15-30</option>
      <option value='30-40'>30-40</option>
      <option value='40-50'>40-50</option>
      <option value='50-60'>50-60</option>
      <option value='60-70'>60-70</option>
      <option value='70-90'>70-90</option>            
      <option value='>90'>>90</option>      
      </select>
      <input type="text" id="userLimit" id="userLimit" value="10000" style="width:200px"/>
     	<a href="#" onclick="refresh();"> Aggiorna</a>

           
    <script>

    $.ajax({
        type: "GET",
    	url: serverUrl + "/modal/api/1.0.0/prestazioni",
    	async: false,
    	error: function(e) {
    		//error({'error': e});
    	    alert("Impossibile comunicare con il servizio " + e);
    	},
    	success: function( response ) {		    		    
    		addOptions("#prestazioni", response);    		
    	}
    });
    
    function addOptions(id, optionList)
    {
    	var select = $(id);    	
    	for(var i = 0; i < optionList.length; i++)
    	{
    		var option = optionList[i];
    		select.append('<option value="' + option + '">' + option + '</option>');
    	}
    }
    
    
     
    
      
      function refresh()
      {
    	  $("#ajaxloader").show();
    	  
      	
      	var url = serverUrl + "/modal/api/1.0.0/pathPrestazioniNelTempo?"

      	var prestazione = $('#prestazioni').find(":selected").text();
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
      	url += "&eta=" + eta;

      	$.ajax({
    	    type: "GET",
    		url: url,
    		async: true,
    		error: function(e) {
    			//error({'error': e});
    			$("#ajaxloader").hide();
    		    alert("Impossibile comunicare con il servizio " + e);
    		},
    		success: function( model ) {
    			$("#ajaxloader").hide();
    			
    			var json = {
    					"id": 1, 
    					"name": model.name,
    				     "data": {
    				      "count": model.count,
   					      "max": model.max,
					      "min": model.min,
					      "average": model.average,
					      "children": model.childrenCount,
					      "percentage": 100
    				    }, 
    				    "children": [],
    				    
    			};
    			
    			populateJSON(model.count, json, model.children, 1);  
    			
    			json.data.children = json.children.length;
    			
    			$('#infovis').css("height", $(window).height() + "px");
    			$('#infovis').html("");
    			init_hypertree(json);    			    			
    		}
    	});      	      	      				      
      }                 
      var id = 1;
      
      
      function populateJSON(totalCount, node, children, level)
      {    	   
    	  var treshould = 10 / Math.pow(level, 2);
    	  
    	  for(var i = 0; i < children.length; i++)
    	  {    		
    		  var child = children[i];
    	  
    		  var percentage = (100 * child.count / node.data.count)
    		  if(percentage >= 1)
    		  {
	    	  	  var nodeChild = {
						"id": "id:" + level + "-" + (++id), 
						"name": child.name,
					     "data": {
					      "count": child.count,
					      "max": child.max,
					      "min": child.min,
					      "average": child.average,
					      "children": child.childrenCount,
					      "percentage": (100 * child.count / totalCount)
					    }, 
					    "children": []					    
					};
	    	  	  
	    	  	  node.children.push(nodeChild);
	    	  	  
	    	  	  populateJSON(totalCount, nodeChild, child.children, level + 1);
	    	  	  
	    	  	  nodeChild.data.children = nodeChild.children.length;
    		  }	
    	  }    	  	        	  
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
 		    
 		return 'rgba(' + red + ', ' + green+ ', ' + blue + ', 0.2)';
    		
      }
      
    </script>
  	<div id="container">
			<div id="center-container">
    			<div id="infovis"></div>    
			</div>
		</div>
		
		<script>
		$('#infovis').css("height", ($(window).height() - $('#branche').height() - 20) + "px");
		
		$(document.body).append('<img id="ajaxloader" src="images/ajax-loader.gif" alt="Wait" style="vertical-align: middle; width: 90px; height:90px" />');
		$("#ajaxloader").css({position: 'absolute', top: (($(window).height() / 2) - ($("#ajaxloader").width() / 2)) + "px", left: ($(window).width() - $("#ajaxloader").width()) / 2 + "px", zIndex: 1000});
		$("#ajaxloader").hide();

		
		</script>
  </body>
</html>
