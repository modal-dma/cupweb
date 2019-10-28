<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0/dist/Chart.min.js"></script>	
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-colorschemes"></script>
<script src="js/widgetLoader.js"></script>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">

<!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
 
 <link rel="stylesheet" href="css/style.css">

<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
<span class="ui-widget">
<%@include file="widgetAnni.jsp" %>
 <a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>
 </span>
<!-- 
<div class="chart-container" style="position: relative; height:80vh; width:90vw">
 -->


<!-- </div>  -->
<script>


var myChart = null;
/*
$.ajax({
    type: "GET",
	url: "http://localhost:8090/modal/api/1.0.0/branche",
	async: false,
	error: function(e) {
		error({'error': e});
	       //alert("Impossibile comunicare con il servizio DSS " + e.message);
	},
	success: function( response ) {		    		    
	    addOptions("#branche", response);
	}
});
*/

$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/prestazioniAltreBranche",
		async: false,
		error: function(e) {
			alert("Impossibile comunicare con il servizio: " + e.message);
		},
		success: function( response ) {		    		    
		    printChart(response);
		}
	});
	

function printChart(model)
{
	var count = model.data[0].length;
	var backgroundColorArray = [];
	var frequency = .3;
	var amplitude = 127;
	var center = 128;
	var phase = 128;
	
	for(var i = 0; i < count; i++)
	{
		var red   = Math.sin(frequency*i+2+phase) * amplitude + center;
	    var green = Math.sin(frequency*i+0+phase) * amplitude + center;
	    var blue  = Math.sin(frequency*i+4+phase) * amplitude + center;
	    
		//var color = 20 + i * 2;
		backgroundColorArray.push('rgba(' + red + ', ' + green+ ', ' + blue + ', 0.2)');
	}
	
	if(myChart != null)
	{
		$("#myChart").remove();		
	}
	
	var h = $(document).height() - 20;
	var w = $("body").width();
	$("body").append('<canvas id="myChart" width="' + w + '" height="' + h + '" style="margin-top: 10px"></canvas>');		

		
	var ctx = document.getElementById('myChart').getContext('2d');
	myChart = new Chart(ctx, {
    	type: 'bar',
    	data: {
	        labels: model.labels,
	        datasets: [{
	            label: '# di prestazioni per branca',
	            data: model.data[0],	            
	            backgroundColor: backgroundColorArray,
	            /*
	            borderColor: [
	                'rgba(255, 99, 132, 1)',
	                'rgba(54, 162, 235, 1)',
	                'rgba(255, 206, 86, 1)',
	                'rgba(75, 192, 192, 1)',
	                'rgba(153, 102, 255, 1)',
	                'rgba(255, 159, 64, 1)'
	            ],*/
	            borderWidth: 1
	        }]
	    },
	    options: {
	    	plugins: {
	            colorschemes: {
	                scheme: 'brewer.Paired12'
	            }
	        },
	    	aspectRatio: 4/3,
	    	responsive: true,
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    autoSkip: false
	                }
	            }]
	        }	        
	    }
	});
	
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
     
	 var url = serverUrl + "/modal/api/1.0.0/prestazioniAltreBranche?";
	
	 url += "startdate=01/01/" + annoPartenza + "&enddate=31/12/" + annoFine + "&";
	
	$.ajax({
	    type: "GET",
		url: url,
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
</script>

</body>
</html>