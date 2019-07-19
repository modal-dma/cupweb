<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

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
    </style>
  </head>

  <body>  
    <div id="floating-panel">
    <img id="updown" src="images/ic_arrow_drop_up_48pt.png" style="position: absolute; top: 0px; right: 10px" onClick="togglePanel();"/>
    <!--  
      <button onclick="toggleHeatmap()">Toggle Heatmap</button>
      <button onclick="changeGradient()">Change gradient</button>
      <button onclick="changeRadius()">Change radius</button>
      <button onclick="changeOpacity()">Change opacity</button>
      <p>
      -->
      <select multiple id="prestazioni" name="groupid" style="width:60%;height:300px;">
      </select>
     	
     	<a id="refresh" href="#" onclick="refresh();"> Aggiorna</a>
            
    </div>
    <div id="map"></div>
    
    <script>

    //const serverUrl = "http://localhost:8090";
    const serverUrl = "http://192.168.1.20:8090";
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
    	var select = $(id);    	
    	for(var i = 0; i < optionList.length; i++)
    	{
    		var option = optionList[i];
    		select.append('<option value="' + option + '">' + option + '</option>');
    	}
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
	   	
	   	for(i = 0; i < heatmapData.length; i++)
	   	{
	   		var item = heatmapData[i];
	   		var heatmapItem = {location: new google.maps.LatLng(item.lat, item.lon), weight: item.weight};
	   		data.push(heatmapItem);
	   		
	   		// Add the marker at the clicked location, and add the next-available label
	        // from the array of alphabetical characters.
	        var marker = new google.maps.Marker({
	          position: heatmapItem.location,
	          label: {
	              text: "" + item.weight,
	              fontFamily: "'Domine', serif",
	              fontSize: "10px",
	              fontWeight: "bold",
	              color: "white"              
	          },
	          map: map
	        });
	   	}
	   	
	   	return data;    	  	   
   	  }
      
      function refresh()
      {    	  	
    	$("#ajaxloader").show();
      	
    	togglePanel();
    	
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
      	
      	//http://localhost:8090/modal/api/1.0.0/heatmapPrestazioni?prestazione=AMNIOCENTESI&limit=100
      			
      	var url = serverUrl + "/modal/api/1.0.0/heatmapPrestazioni?"

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
    		
    	  }
    	  else
    	  {
    	  	$('#floating-panel').addClass("close");
    	  	$('#prestazioni').css("visibility", "hidden");
    	  	$('#updown').attr("src", "images/ic_arrow_drop_down_black_48dp.png");
    	  	$('#refresh').css("visibility", "hidden");
    	  }
      }
      
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=yourkey&libraries=visualization&callback=initMap">
    </script>
  </body>
</html>
</body>
</html>