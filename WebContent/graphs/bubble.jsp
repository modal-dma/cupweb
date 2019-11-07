<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="../js/constants.js"></script>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="http://dimplejs.org/dist/dimple.v2.0.0.min.js"></script>

<meta charset="ISO-8859-1">

<!-- Custom fonts for this template-->
  <link href="../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="../vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
 
 <link rel="stylesheet" href="../css/style.css">

<script src="../js/widgetLoader.js"></script>

<title>Bar Chart</title>
</head>
<body>
<div class="menubar">
<span class="ui-widget">
<%@include file="widgetAnni.jsp" %>
<a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>

</span>
</div>
<script>

var urlParams = new URLSearchParams(location.search);
var startdate = urlParams.get('startdate');  
var enddate = urlParams.get('enddate'); 

$(document).ready(function() {
	
	console.debug("start");
	
	showLoader();

	if(startdate && enddate)
	{
		$.ajax({
			    type: "GET",
				url: serverUrl + "/modal/api/1.0.0/prestazioniPerBrancaPerComune?startdate="+startdate + "&enddate="+enddate,
				async: true,
				error: function(e) {
					hideLoader();
					alert("Impossibile comunicare con il servizio " + e.message);
				},
				success: function( response ) {
					console.debug("hide");
					hideLoader();
				    printChart(response);
				}
			});
	}
	else
	{
		$.ajax({
		    type: "GET",
			url: serverUrl + "/modal/api/1.0.0/prestazioniPerBrancaPerComune",
			async: true,
			error: function(e) {
				hideLoader();
				alert("Impossibile comunicare con il servizio DSS " + e.message);
			},
			success: function( response ) {		    		    
			    printChart(response);
			    hideLoader();
			}
		});
	
	}
});
	
function printChart(model)
{
	// Draw areas for day stacked by brand
	var svg = dimple.newSvg("body", 2000, 800);
	var data = [];
	
	var count = model.values.length;
	
	for(var i = 0; i < count; i++)
	{
		var value = model.values[i];
		
		var point = {"Branca" : value.x, "Comune": value.y, "Prestazioni": value.data};
		data.push(point);
	}
		
	var h = $(document).height() - 300;
	var w = $("body").width() - 200;
	
	var myChart = new dimple.chart(svg, data);
    myChart.setBounds(200, 30, w, h)
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
	var anni = parseInt($('#anni').find(":selected").attr("value"));
    var annoPartenza = parseInt($('#annoPartenza').find(":selected").attr("value"));
    
    var annoFine = annoPartenza + anni;   
	
	location.href = "bubble.jsp?startdate=01/01/" + annoPartenza + "&enddate=31/12/" + annoFine;
	
}

</script>

</body>
</html>