<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.bundle.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">	
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.css">
<script src="js/widgetLoader.js"></script>
<!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
  
<link rel="stylesheet" href="css/style.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
<span class="ui-widget" >
  <%@include file="widgetPrestazioni.jsp" %>
  
  <a href="#" onclick="refresh();"> <i class="fas fa-sync-alt"></i> </a>
</span>
<script>

var myChart = null;



function refresh()
{
	  $("#ajaxloader").show();
	  
	var prestazione = $('#prestazioni').find(":selected").text();
	
	var prestazione = $('#prestazioni-auto').val();
   	if(prestazione == ""  || prestazione == undefined)
   		prestazione = $('#prestazioni').find(":selected").text();
		
	var url = serverUrl + "/modal/api/1.0.0/etaPerPrestazione?"
	      	
	url += "prestazione=" + prestazione;
	
	
	$.ajax({
	    type: "GET",
		url: url,
		async: true,
		error: function(e) {
			
			$("#ajaxloader").hide();
		    alert("Impossibile comunicare con il servizio" + e.message);
		},
		success: function( response ) {		    		    
		    printChart(response);
		}
	});	    	    	      				     
}                 

function printChart(model)
{
	var count = model.data[0].length;
	var backgroundColorArray = [];
	var frequency = 4;
	var amplitude = 127;
	var center = 128;
	var phase = 1;
	
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
	
	var h = $(document).height() - 40;
	var w = $("body").width();
	$("body").append('<canvas id="myChart" width="' + w + '" height="' + h + '" style="margin-top: 10px"></canvas>');		
	
	var ctx = document.getElementById('myChart').getContext('2d');
	myChart = new Chart(ctx, {
    	type: 'bar',
    	data: {
	        labels: model.labels,
	        datasets: [{
	            label: '# eta per prestazioni',
	            data: model.data[0],	            
	            backgroundColor: colors,
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
	    	aspectRatio: 1,
	    	responsive: true,
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true
	                }
	            }]
	        },
	        legend: {
	        	display: false,
	        	label: 
	        		{
	        		
	        		}
	        },
	    }
	});
	
	$("#ajaxloader").hide();
	//myChart.canvas.parentNode.style.height = '300px';
	//myChart.canvas.parentNode.style.width = '128px';
}

function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}

$(document.body).append('<img id="ajaxloader" src="images/ajax-loader.gif" alt="Wait" style="vertical-align: middle; width: 90px; height:90px" />');
$("#ajaxloader").css({position: 'absolute', top: (($(window).height() / 2) - ($("#ajaxloader").width() / 2)) + "px", left: ($(window).width() - $("#ajaxloader").width()) / 2 + "px", zIndex: 1000});
$("#ajaxloader").hide();


</script>

</body>
</html>