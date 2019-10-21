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
<script language="javascript" type="text/javascript" src="js/prenotazionePerBrancaDopoBranca.js"></script>

  </head>

  <body>    
      <select id="prestazioni" name="groupid" style="width:60%;">
    	</select>
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
    	  
      	var min = 5000, max = 0;
      	
      	var years = $(".year");
      	
      	for(var i = 0; i < years.length; i++)
      	{
      		var year = years[i];
      	
      		if(year.checked)
      		{
      			var v = parseInt(year.id);
      			if(v < min)
      				min = v;
      			
      			if(v > max)
      				max = v;			
      		}
      	}
      	//var branca = $('#branche').find(":selected").text();
      	var prestazione = $('#prestazioni').find(":selected").text();
      	
      	//http://localhost:8090/modal/api/1.0.0/heatmapPrestazioni?prestazione=AMNIOCENTESI&limit=100
      			
      	var url = serverUrl + "/modal/api/1.0.0/prenotazioniPerPrestazioneDopoPrestazione?"

      	if(min < 5000) // trovato almeno uno
      		url += "startdate=01/01/" + min + "&enddate=31/12/" + max + "&";
      	      	
      	url += "prestazione=" + prestazione;
      	
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
    			var count = model.data[0].length;
    			
    			var json = {
    					"id": prestazione, 
    					"name": prestazione,
    				    "data": {
    				      "$area": count,
    				      "$dim": count,
    				      "$color": "#910E8F"
    				    },
    				    "children": []
    			};
    			
    			for(var i = 0; i < count && i < 15; i++)
    			{
    				var data = model.data[0][i];
    				var label = model.labels[i];
    				var child = {
    					"id": label, 
        				"name": label + " (" + data + ")",
        				"data": {
        				      "$area": data,
        				      "$dim": data,
        				      "$color": "#D21B7A"
        				},
        				"children": []
    				};	
    				
    				json.children.push(child);
    			}    			    	
    			
    			
    			$('#infovis').css("height", $(window).height() + "px");
    			$('#infovis').html("");
    			createicicle(json);    			    			
    		}
    	});      	      	      				      
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
