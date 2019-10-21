<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.bundle.min.js"></script>	
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.css">
<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
 <span class="ui-widget" >
età: <select id="eta" name="groupid" style="width:60px;">
    	</select>
     	<a href="#" onclick="refresh();"> Aggiorna</a>
</span>
<div class="chart-container" style="position: relative; height:60vh; width:60vw">
</div>
<script>

var myChart = null;

$.ajax({
    type: "GET",
	url: serverUrl + "/modal/api/1.0.0/eta",
	async: false,
	error: function(e) {
		//error({'error': e});
	    alert("Impossibile comunicare con il servizio " + e);
	},
	success: function( response ) {		    		    
		addOptions("#eta", response);    		
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
	var eta = $('#eta').find(":selected").text();
	
	//http://localhost:8090/modal/api/1.0.0/heatmapPrestazioni?prestazione=AMNIOCENTESI&limit=100
			
	var url = serverUrl + "/modal/api/1.0.0/prestazioniPerEta?"

	if(min < 5000) // trovato almeno uno
		url += "startdate=01/01/" + min + "&enddate=31/12/" + max + "&";
	      	
	url += "eta=" + eta;
	
	
	$.ajax({
	    type: "GET",
		url: url,
		async: false,
		error: function(e) {
			
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
	
	$(".chart-container").append('<canvas id="myChart"></canvas>');
	
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
	        }
	    }
	});
	
	myChart.canvas.parentNode.style.height = '300px';
	//myChart.canvas.parentNode.style.width = '128px';
}

function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}

</script>

</body>
</html>