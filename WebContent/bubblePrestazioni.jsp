<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="js/constants.js"></script>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="http://dimplejs.org/dist/dimple.v2.0.0.min.js"></script>
<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
<div class="ui-widget">
  <label for="prestazioni">Prestazioni: </label>
  <input id="prestazioni">
</div>
<!-- 
<select id="prestazioni" name="groupid" style="width:20%;">
    	</select>
-->
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

function refresh()
{
	  $("#ajaxloader").show();
	
	//var prestazione = $('#prestazioni').find(":selected").text();
	var prestazione = $('#prestazioni').val();
	
	var url = serverUrl + "/modal/api/1.0.0/prestazioniPerUOPPerResidenza?"

    	
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
			
		    printChart(model);    			    			
		}
	});      	      	      				      
}                 
	
var svg = null;
var myChart = null;

function printChart(model)
{
	// Draw areas for day stacked by brand
	if(svg)
	{
		$(svg[0]).remove()
		//$('body').remove(svg);
		//$(myChart).remove();
	}
	
	svg = dimple.newSvg("body", 2000, 800);
	var data = [];
	
	var count = model.values.length;
	
	for(var i = 0; i < count; i++)
	{
		var value = model.values[i];
		
		var point = {"UOP" : value.x, "Residenza": value.y, "Prestazioni": value.data};
		data.push(point);
	}
		
	myChart = new dimple.chart(svg, data);
    myChart.setBounds(200, 100, 1400, 600)
    var x = myChart.addCategoryAxis("x", "Residenza");    
    myChart.addCategoryAxis("y", "UOP");
    myChart.addMeasureAxis("z", "Prestazioni");
    myChart.addSeries("Prestazioni", dimple.plot.bubble);
    myChart.addLegend(140, 10, 360, 20, "right");
    myChart.draw();
}

function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}


</script>

</body>
</html>