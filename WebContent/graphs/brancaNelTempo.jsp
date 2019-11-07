<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="../js/constants.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0/dist/Chart.min.js"></script>	
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-colorschemes"></script>
<meta charset="ISO-8859-1">
<title>Branca nel tempo</title>
</head>
<body>
<select id="branca" name="groupid" style="width:60%;">

</select> 
<br/>

 <a href="#" onclick="refresh();"> Aggiorna</a>
<!-- 
<div class="chart-container" style="position: relative; height:80vh; width:90vw">
 -->


<!-- </div>  -->
<script>


var myChart = null;

$.ajax({
    type: "GET",
	url: serverUrl + "/modal/api/1.0.0/branche",
	async: false,
	error: function(e) {
		//error({'error': e});
	    alert("Impossibile comunicare con il servizio " + e.message);
	},
	success: function( response ) {		    		    
		addOptions("#branca", response);
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
	
	$("body").append('<canvas id="myChart"></canvas>');
		
	var ctx = document.getElementById('myChart').getContext('2d');
	myChart = new Chart(ctx, {
    	type: 'line',
    	data: {
	        labels: model.labels,
	        datasets: [{
	            label: '# di prestazioni per branca nel tempo',
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
	    	//aspectRatio: 4/3,
	    	//responsive: true,
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
	
	myChart.canvas.parentNode.style.height = '300px';	
	//myChart.canvas.parentNode.style.width = '128px';
}

function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}

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
	var branca = $('#branca').find(":selected").text();
	
	var url = serverUrl + "/modal/api/1.0.0/prestazioniBrancaNelTempo?branca="+ branca;
					
	$.ajax({
	    type: "GET",
		url: url,
		async: false,
		error: function(e) {
			//error({'error': e});
		    alert("Impossibile comunicare con il servizio DSS " + e.message);
		},
		success: function( response ) {		    		    
		    printChart(response);
		}
	});
	
}
</script>

</body>
</html>