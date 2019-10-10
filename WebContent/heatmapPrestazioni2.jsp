<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- drawer.css -->
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/drawer/3.2.2/css/drawer.min.css">
<!-- jquery & iScroll -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/iScroll/5.2.0/iscroll.min.js"></script>
<!-- drawer.js -->
<script src="http://cdnjs.cloudflare.com/ajax/libs/drawer/3.2.2/js/drawer.min.js"></script>
<script src="js/constants.js"></script>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Heatmaps</title>

    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #floating-panel {
        position: absolute;
        top: 10px;
        left: 25%;
        z-index: 5;
        background-color: #fff;
        padding: 5px;
        border: 1px solid #999;
        text-align: center;
        font-family: 'Roboto','sans-serif';
        line-height: 30px;
        padding-left: 10px;
      }
      #floating-panel {
        background-color: #fff;
        border: 1px solid #999;
        left: 25%;
        padding: 5px;
        position: absolute;
        top: 10px;
        z-index: 5;
        height:300px;
      }
      
      .close {
        height:40px !important;
      }
      
      .switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

.switch input { 
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

    </style>
  </head>

<script>
$(document).ready(function() {
	$(document.body).addClass("drawer drawer--left")
  	$('.drawer').drawer();
});
</script>

<body class="drawer drawer--left">  

<header role="banner">
    <button type="button" class="drawer-toggle drawer-hamburger">
      <span class="sr-only">toggle navigation</span>
      <span class="drawer-hamburger-icon"></span>
    </button>
    <nav class="drawer-nav" role="navigation">    
    
    <!--  
      <button onclick="toggleHeatmap()">Toggle Heatmap</button>
      <button onclick="changeGradient()">Change gradient</button>
      <button onclick="changeRadius()">Change radius</button>
      <button onclick="changeOpacity()">Change opacity</button>
      <p>
      -->      
      <div class="ui-widget">
  <label for="prestazioni">Prestazioni: </label>
  <input id="prestazioni">
</div>
      <span id="uop-panel">
      	<input type="radio" name="uop" value="residenza"> Residenza<br>
		<input type="radio" name="uop" value="comune"> Comune ASL<br>
		<input type="radio" name="uop" value="nonresidenti"> Non Residenti      
	</span>
	
      <p/>
     	<a id="refresh" href="#" onclick="refresh();" style="margin-left:30px"> Aggiorna</a>
            
    </nav>
    </header>
    <main role="main" style="margin: 100px; height:100%">
    
    <div id="map"></div>
    
    <script>

    var heatmapData = null;
    
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
    		
     		$(document.body).append('<img id="ajaxloader" src="images/ajax-loader.gif" alt="Wait" style="vertical-align: middle; width: 90px; height:90px" />');
    		$("#ajaxloader").css({position: 'absolute', top: (($(document.body).height() / 2) - ($("#ajaxloader").width() / 2)) + "px", left: ($(document.body).width() - $("#ajaxloader").width()) / 2 + "px", zIndex: 1000});
    		$("#ajaxloader").hide();
    	}
    });
    
    function addOptions(id, optionList)
    {
    	$( id).autocomplete({
  	      source: optionList
  	    });
    	/*
    	var select = $(id);    	
    	for(var i = 0; i < optionList.length; i++)
    	{
    		var option = optionList[i];
    		select.append('<option value="' + option + '">' + option + '</option>');
    	}
    	*/
    }
    
    
      // This example requires the Visualization library. Include the libraries=visualization
      // parameter when you first load the API. For example:
      // <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=visualization">

      
      var map, heatmap;

      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 9,
          center: {lat: 40.8535224, lng: 14.1029229},
          mapTypeId: 'satellite'
        });
      }

      function toggleHeatmap() {
        heatmap.setMap(heatmap.getMap() ? null : map);
      }

      function changeGradient() {
        var gradient = [
          'rgba(0, 255, 255, 0)',
          'rgba(0, 255, 255, 1)',
          'rgba(0, 191, 255, 1)',
          'rgba(0, 127, 255, 1)',
          'rgba(0, 63, 255, 1)',
          'rgba(0, 0, 255, 1)',
          'rgba(0, 0, 223, 1)',
          'rgba(0, 0, 191, 1)',
          'rgba(0, 0, 159, 1)',
          'rgba(0, 0, 127, 1)',
          'rgba(63, 0, 91, 1)',
          'rgba(127, 0, 63, 1)',
          'rgba(191, 0, 31, 1)',
          'rgba(255, 0, 0, 1)'
        ]
        heatmap.set('gradient', heatmap.get('gradient') ? null : gradient);
      }

      function changeRadius() {
        heatmap.set('radius', heatmap.get('radius') ? null : 30);
      }

      function changeOpacity() {
        heatmap.set('opacity', heatmap.get('opacity') ? null : 1);
      }

      /* Data points defined as a mixture of WeightedLocation and LatLng objects */
      /*
      var heatMapData = [
        {location: new google.maps.LatLng(37.782, -122.447), weight: 0.5},
        new google.maps.LatLng(37.782, -122.445),
        {location: new google.maps.LatLng(37.782, -122.443), weight: 2},
        {location: new google.maps.LatLng(37.782, -122.441), weight: 3},
        {location: new google.maps.LatLng(37.782, -122.439), weight: 2},
        new google.maps.LatLng(37.782, -122.437),
        {location: new google.maps.LatLng(37.782, -122.435), weight: 0.5},

        {location: new google.maps.LatLng(37.785, -122.447), weight: 3},
        {location: new google.maps.LatLng(37.785, -122.445), weight: 2},
        new google.maps.LatLng(37.785, -122.443),
        {location: new google.maps.LatLng(37.785, -122.441), weight: 0.5},
        new google.maps.LatLng(37.785, -122.439),
        {location: new google.maps.LatLng(37.785, -122.437), weight: 2},
        {location: new google.maps.LatLng(37.785, -122.435), weight: 3}
      ];
      */
   // Heatmap data: 500 Points
      function getHeatmapData() {
   
	   	var data = [];
	   	var i = 0;
	   	
	   	var infowindow =  new google.maps.InfoWindow({
    		content: ''
    	});        	   	
	   	
	   	for(i = 0; i < heatmapData.length; i++)
	   	{
	   		var item = heatmapData[i];
	   		var heatmapItem = {location: new google.maps.LatLng(item.lat, item.lon), weight: item.weight};
	   		data.push(heatmapItem);
	   		
	   		
	   	 	var markerIcon = {
	   	        url: 'http://image.flaticon.com/icons/svg/252/252025.svg',
	   	        scaledSize: new google.maps.Size(20, 20),
	   	        origin: new google.maps.Point(0, 0),
	   	        //anchor: new google.maps.Point(32,65),
	   	        labelOrigin:  new google.maps.Point(20,-10),
	   	    };
	   	 
	   		// Add the marker at the clicked location, and add the next-available label
	        // from the array of alphabetical characters.
	        var marker = new google.maps.Marker({
	          position: heatmapItem.location,
	          animation: google.maps.Animation.DROP,
	          icon: markerIcon,
	          label: {
	              text: "" + item.weight,
	              fontFamily: "'Domine', serif",
	              fontSize: "10px",
	              fontWeight: "bold",
	              color: "white"              
	          },
	          map: map
	        });
	   		
	     	// add an event listener for this marker
	     	var htmlInfo = "<p>" + item.name + "<br/>" + item.weight + (item.averageDistance ? "<br/>average distance: " + item.averageDistance.toFixed(2) + "<br/>min distance: " + item.minDistance.toFixed(2) + "<br/>max distance: " + item.maxDistance.toFixed(2) + "<br/>comune più distante: " + item.maxComune + "</p>" : "");
	     	
			bindInfoWindow(marker, map, infowindow, htmlInfo);  
	     
/*	        var infowindow =  new google.maps.InfoWindow({
	    		content: item.name + "<br/>" + item.weight,
	    		map: map,
	    		position: heatmapItem.location
	    	});
	*/   
			google.maps.event.addListener(marker, 'mouseout', function() {
		    	infowindow.close();
		    });
	
	        //google.maps.event.addListener(marker, 'mouseover', function() {
	        //	infowindow.open(map, this);
	        //});
	        
	        
	        
	   	}
	   	
	   	return data;    	  	   
   	  }
      
      function bindInfoWindow(marker, map, infowindow, html) 
      { 
    		google.maps.event.addListener(marker, 'mouseover', function() { 
    			infowindow.setContent(html); 
    			infowindow.open(map, marker); 
    		});
      }
    		
      function refresh()
      {    	  	
    	$("#ajaxloader").show();
      	
    	//togglePanel();
    	
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
      	var prestazioniSelezionate = $('#prestazioni').find(":selected");
      	var prestazioni = "";
      	for(var i = 0; i < prestazioniSelezionate.length; i++)
      	{
      		prestazioni += $(prestazioniSelezionate[i]).text() + ";";
      	}
      	
      	
      	var uop = $("input[name='uop']:checked"). val();
      	
      	//http://localhost:8090/modal/api/1.0.0/heatmapPrestazioni?prestazione=AMNIOCENTESI&limit=100
      			
      	var url = serverUrl + "/modal/api/1.0.0/heatmapPrestazioni?uop=" + uop + "&";

      	if(min < 5000) // trovato almeno uno
      		url += "startdate=01/01/" + min + "&enddate=31/12/" + max + "&";
      	      	
      	url += "prestazione=" + prestazioni + "&limit=50";
      	
      	$.ajax({
    	    type: "GET",
    		url: url,
    		async: true,
    		error: function(e) {
    			//error({'error': e});
    			$("#ajaxloader").hide();
    		    alert("Impossibile comunicare con il servizio " + e);
    		},
    		success: function( response ) {		
    			$("#ajaxloader").hide();
    			heatmapData = response;
    			initMap();
    	        heatmap = new google.maps.visualization.HeatmapLayer({
    	            data: getHeatmapData(),
    	            map: map
    	          });
    	        
    	        //heatmap.set('dissipating', false);
    	        changeRadius();
    	        changeGradient();
    	        changeOpacity();

    		}
    	});      	      	      				      
      }
            
      function togglePanel()
      {
    	  if($('#floating-panel').hasClass("close"))   
    	  {
    		$('#floating-panel').removeClass("close");
    		$('#prestazioni').css("visibility", "visible");
    		$('#updown').attr("src", "images/ic_arrow_drop_up_48pt.png");
    		$('#refresh').css("visibility", "visible");
    		$('#uop-panel').css("visibility", "visible");
    		
    	  }
    	  else
    	  {
    	  	$('#floating-panel').addClass("close");
    	  	$('#prestazioni').css("visibility", "hidden");
    	  	$('#updown').attr("src", "images/ic_arrow_drop_down_black_48dp.png");
    	  	$('#refresh').css("visibility", "hidden");
    	  	$('#uop-panel').css("visibility", "hidden");
    	  }
      }
      
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCAgiTQIokgzqUeMf2UOHg01blipygNBRI&libraries=visualization&callback=initMap">
    </script>
    </main>
  </body>
</html>
</body>
</html>