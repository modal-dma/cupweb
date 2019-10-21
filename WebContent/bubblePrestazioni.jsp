<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="js/constants.js"></script>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="http://dimplejs.org/dist/dimple.v2.0.0.min.js"></script>

<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
<span style="background-color: white; text-align: center;">
  <span class="ui-widget" >
  <label for="prestazioni-auto">Prestazioni: </label>
  <input id="prestazioni-auto" style="width:150px;">
  <select id="prestazioni" name="groupid" style="width:150px;">
</select> 
      <label for="comuni-auto">Comuni: </label>
 	  <input id="comuni-auto" style="width:150px;">
 	<select id="comuni" name="groupid" style="width:150px;">
 	</select> 
 	<!-- 
   	 Sesso:<select id="gender" name="gender" style="width:70px;">    
      <option value='0'>Tutti</option>
      <option value='1'>Maschio</option>
      <option value='2'>Femmina</option>
      </select>
      Anno:<select id="annoPartenza" name="annoPartenza" style="width:70px;">    
      <option value='2014'>2014</option>
      <option value='2015'>2015</option>
      <option value='2016'>2016</option>
      <option value='2017'>2017</option>
      <option value='2018'>2018</option>
      <option value='2019'>2019</option>
      </select>
      Durata anni:<select id="anni" name="anni" style="width:40px;">         
      <option value='1'>1</option>
      <option value='2'>2</option>
      <option value='3'>3</option>
      <option value='4'>4</option>
      <option value='5'>5</option>
      </select>
      Eta:<select id="eta" name="eta" style="width:65px;">         
      <option value='0-14'>0-14</option>
      <option value='15-30'>15-30</option>
      <option value='30-40'>30-40</option>
      <option value='40-50'>40-50</option>
      <option value='50-60'>50-60</option>
      <option value='60-70'>60-70</option>
      <option value='70-90'>70-90</option>            
      <option value='>90'>>90</option>
      <option value='tutti'>Tutti</option>      
      </select>
       -->
      Minimo: <input type="text" id="minCount" id="minCount" value="20" style="width:40px"/>
     	<a href="#" onclick="refresh();"> Aggiorna</a>
     	</span>
     </span>   
     
<!-- 
<select id="prestazioni" name="groupid" style="width:20%;">
    	</select>
-->
     	
<script>

$.ajax({
    type: "GET",
	url: serverUrl + "/modal/api/1.0.0/comuni",
	async: false,
	error: function(e) {
		error({'error': e});
	       //alert("Impossibile comunicare con il servizio DSS " + e.message);
	},
	success: function( response ) {		    		    
		addOptions1("#comuni", response);
	}
});

var prestazioniDataset;
$.ajax({
    type: "GET",
	url: serverUrl + "/modal/api/1.0.0/prestazioniConteggio",
	async: false,
	error: function(e) {
		//error({'error': e});
	    alert("Impossibile comunicare con il servizio " + e);
	},
	success: function( response ) {
		prestazioniDataset = response,
		addOptions("#prestazioni", response);    		
	}
});

function addOptions1(id, optionList)
{
	$(id + "-auto").autocomplete({
	      source: optionList
	    });
	
	var select = $(id);    	     	
	select.append('<option value="tutti" selected> </option>');
	for(var i = 0; i < optionList.length; i++)
	{
		var option = optionList[i];
		select.append('<option value="' + option + '">' + option + '</option>');
	}
	
}
function addOptions(id, model)
{
	var items = [];
	
	for(var i = 0; i < model.labels.length; i++)
	{
		var item = model.data[0][i];
		
		items.push({'label': model.labels[i], 'value': model.labels[i], 'count':item});
	}
	
	$( id + "-auto").autocomplete({
	      source: items,
	      select: function( event, ui ) {
	    	  //console.log(ui);
	    	  $('#conteggio').text(' totale:' + ui.item.count);
	      }
	    });

	var select = $(id);    	
	select.append('<option value="tutti" selected> </option>');
	for(var i = 0; i < model.labels.length; i++)
	{
		var option = model.labels[i];
		select.append('<option value="' + option + '">' + option + '</option>');
	}
	
}

function refresh()
{
	  $("#ajaxloader").show();
	
	//var prestazione = $('#prestazioni').find(":selected").text();
	var prestazione = $('#prestazioni-auto').val();
    if(prestazione == ""  || prestazione == undefined)
    	prestazione = $('#prestazioni').find(":selected").text();
		
	var comune = $('#comuni-auto').val();
	if(comune == ""  || comune == undefined)
		comune = $('#comuni').find(":selected").text();
	
	var minCount = $('#minCount').val();
	
//	var gender = $('#gender').find(":selected").attr("value");
//  	var anni = $('#anni').find(":selected").attr("value");
//  	var annoPartenza = $('#annoPartenza').find(":selected").attr("value");
//  	var eta = $('#eta').find(":selected").attr("value");
  	
	
	var url = serverUrl + "/modal/api/1.0.0/prestazioniPerUOPPerResidenza?"

    	
	url += "prestazione=" + prestazione;
	url += "&comune=" + comune;
	url += "&minCount=" + minCount;
//	url += "&gender=" + gender;
//  	url += "&startdate=" + annoPartenza;
//  	url += "&anni=" + anni;
//  	if(eta != "tutti")
//  		url += "&eta=" + eta;

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
			
			
		    printChart(model);    			    			
		}
	});      	      	      				      
}                 
	
var svg = null;
var myChart = null;
var popup;
var mapWeight = {};

function printChart(model)
{
	// Draw areas for day stacked by brand
	if(svg)
	{
		$(svg[0]).remove()
		//$('body').remove(svg);
		//$(myChart).remove();
	}
	
	if(model.values.length > 0)
	{
		svg = dimple.newSvg("body", 2000, 800);
		var data = [];
		
		var count = model.values.length;
		var totale = 0;
		for(var i = 0; i < count; i++)
		{
			var value = model.values[i];
			
			totale += value.data;
			
			var point = {"UOP" : value.x, "Residenza": value.y, "Prestazioni": value.data};
			data.push(point);
			
			mapWeight[value.x + value.y] = value.weight;
		}
			
		var h = $(document).height() - 300;
		var w = $("body").width() - 200;
		
		$('#conteggiofuorisede').text(' fuori sede ' + totale + " su ");
		myChart = new dimple.chart(svg, data);
		myChart.setBounds(200, 30, w, h)
	    var x = myChart.addCategoryAxis("x", "Residenza");    
	    myChart.addCategoryAxis("y", "UOP");
	    myChart.addMeasureAxis("z", "Prestazioni");
	    var s = myChart.addSeries("Prestazioni", dimple.plot.bubble);
	    //myChart.addLegend(140, 10, 360, 20, "right");
	    
	    
	    // Handle the hover event - overriding the default behaviour
      	s.addEventHandler("mouseover", onHover);
      	// Handle the leave event - overriding the default behaviour
      	s.addEventHandler("mouseleave", onLeave);
      
	    myChart.draw();
	}
}

//Event to handle mouse enter
function onHover(e) {
  
  // Get the properties of the selected shape
  var cx = parseFloat(e.selectedShape.attr("cx")),
      cy = parseFloat(e.selectedShape.attr("cy")),
      r = parseFloat(e.selectedShape.attr("r")),
      fill = e.selectedShape.attr("fill"),
      stroke = e.selectedShape.attr("stroke");
      
  // Set the size and position of the popup
  var width = 150,
      height = 100,
      x = (cx + r + width + 10 < svg.attr("width") ?
            cx + r + 10 :
            cx - r - width - 20);
      y = (cy - height / 2 < 0 ?
            15 :
            cy - height / 2);
          
  // Fade the popup fill mixing the shape fill with 80% white
  var popupFillColor = d3.rgb(
              d3.rgb(fill).r + 0.8 * (255 - d3.rgb(fill).r),
              d3.rgb(fill).g + 0.8 * (255 - d3.rgb(fill).g),
              d3.rgb(fill).b + 0.8 * (255 - d3.rgb(fill).b)
          );
  
  // Create a group for the popup objects
  popup = svg.append("g");
  
  // Add a rectangle surrounding the chart
  popup
    .append("rect")
    .attr("x", x + 5)
    .attr("y", y - 5)
    .attr("width", width)
    .attr("height", height)
    .attr("rx", 5)
    .attr("ry", 5)
    .style("fill", popupFillColor)
    .style("stroke", stroke)
    .style("stroke-width", 2);
  
  // Add the series value text
  
  popup
  .append("text")
  .attr("x", x + 10)
  .attr("y", y + 20)
  .text("UOP " + e.xValue)
  .style("font-family", "sans-serif")
  .style("font-size", 10)
  .style("fill", stroke);
  
  popup
  .append("text")
  .attr("x", x + 10)
  .attr("y", y + 30)
  .text("Residenza " + e.yValue)
  .style("font-family", "sans-serif")
  .style("font-size", 10)
  .style("fill", stroke);
  
  popup
  .append("text")
  .attr("x", x + 10)
  .attr("y", y + 10)
  .text("Prestazioni: " + e.seriesValue[0])
  .style("font-family", "sans-serif")
  .style("font-size", 10)
  .style("fill", stroke);
  
  var weight = mapWeight[e.yValue + e.xValue];
  
  popup
  .append("text")
  .attr("x", x + 10)
  .attr("y", y + 50)
  .text("Distanza: " + weight.toFixed(0) + "Km")
  .style("font-family", "sans-serif")
  .style("font-size", 10)
  .style("fill", stroke);
 
    
};

// Event to handle mouse exit
function onLeave(e) {
  
  // Remove the popup
  if (popup !== null) {
    popup.remove();
  }
};
function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}


</script>

</body>
</html>