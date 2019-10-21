<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="http://dimplejs.org/dist/dimple.v2.0.0.min.js"></script>
<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
<input type="checkbox" class="year" id="2013" value="2013"> 2013 | <input type="checkbox" class="year" id="2014" value="2014"> 2014 | <input type="checkbox" class="year" id="2015" value="2015"> 2015 | <input type="checkbox" class="year" id="2016" value="2016"> 2016 | <input type="checkbox" class="year" id="2017" value="2017"> 2017 | <input type="checkbox" class="year" id="2018" value="2018"> 2018 | <input type="checkbox" class="year" id="2019" value="2019"> 2019 | <a href="#" onclick="refresh();"> Aggiorna</a> 

<script>

var urlParams = new URLSearchParams(location.search);
var startdate = urlParams.get('startdate');  
var enddate = urlParams.get('enddate'); 

if(startdate && enddate)
{
$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/prestazioniPerBrancaPerComune?startdate="+startdate + "&enddate="+enddate,
		async: false,
		error: function(e) {
			error({'error': e});
		       //alert("Impossibile comunicare con il servizio DSS " + e.message);
		},
		success: function( response ) {		    		    
		    printChart(response);
		}
	});
}
else
{
	$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/prestazioniPerBrancaPerComune",
		async: false,
		error: function(e) {
			error({'error': e});
		       //alert("Impossibile comunicare con il servizio DSS " + e.message);
		},
		success: function( response ) {		    		    
		    printChart(response);
		}
});

	}
	
function printChart(model)
{
	// Draw areas for day stacked by brand
	var svg = dimple.newSvg("body", 1600, 800);
	var data = [];
	
	var count = model.values.length;
	
	for(var i = 0; i < count; i++)
	{
		var value = model.values[i];
		
		var point = {"Branca" : value.x, "Comune": value.y, "Prestazioni": value.data};
		data.push(point);
	}
		
	var h = $(document).height() - 200;
	var w = $("body").width() - 200;
	
	var myChart = new dimple.chart(svg, data);
    myChart.setBounds(200, 0, w, h)
    var x = myChart.addCategoryAxis("x", "Comune");    
    myChart.addCategoryAxis("y", "Branca");
    myChart.addMeasureAxis("z", "Prestazioni");
    myChart.addSeries("Prestazioni", dimple.plot.bubble);
    //myChart.addLegend(140, 10, 360, 20, "right");
    myChart.draw();
}

function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}

function refresh()
{
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
	
	location.href = "bubble.jsp?startdate=01/01/" + min + "&enddate=31/12/" + max;
	
}

</script>

</body>
</html>