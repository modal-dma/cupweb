<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="../js/constants.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.bundle.min.js"></script>
<script src="../js/widgetLoader.js"></script>	
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.css">
<link rel="stylesheet" href="../css/style.css">
<!-- Custom fonts for this template-->
  <link href="../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="../vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
<div class="menubar">
 <span class="ui-widget" >
età: <select id="eta" name="groupid" style="width:80px;">
    	</select>
    	<a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>
</span>
</div>
<script>

var myChart = null;

$(document).ready(function() {
	
	showLoader();
	
	$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/eta",
		async: true,
		error: function(e) {
			hideLoader();
			//error({'error': e});
		    alert("Impossibile comunicare con il servizio " + e);
		},
		success: function( response ) {
			hideLoader();
			addOptions("#eta", response);    
			
			refresh();
		}
	});	
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
	  showLoader();
	  	
	var eta = $('#eta').find(":selected").text();
			
	var url = serverUrl + "/modal/api/1.0.0/prestazioniPerEta?"
	      	
	url += "eta=" + eta;
	
	
	$.ajax({
	    type: "GET",
		url: url,
		async: true,
		error: function(e) {
			hideLoader();
		    alert("Impossibile comunicare con il servizio" + e.message);
		},
		success: function( response ) {
			hideLoader();
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
	
	var h = $(document).height() - 20;
	var w = $("body").width();
	$("body").append('<canvas id="myChart" width="' + w + '" height="' + h + '" style="margin-top: 10px"></canvas>');		
	
	var ctx = document.getElementById('myChart').getContext('2d');
	myChart = new Chart(ctx, {
    	type: 'bar',
    	data: {
	        labels: model.labels,
	        datasets: [{
	            label: '# prestazioni per eta',
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
	        }
	    }
	});
	
	//myChart.canvas.parentNode.style.height = '300px';
	//myChart.canvas.parentNode.style.width = '128px';
}

function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}

</script>

</body>
</html>