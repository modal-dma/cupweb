<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0/dist/Chart.min.js"></script>	
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-colorschemes"></script>
<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>

<input type="checkbox" class="year" id="2013" value="2013"> 2013 | <input type="checkbox" class="year" id="2014" value="2014"> 2014 | <input type="checkbox" class="year" id="2015" value="2015"> 2015 | <input type="checkbox" class="year" id="2016" value="2016"> 2016 | <input type="checkbox" class="year" id="2017" value="2017"> 2017 | <input type="checkbox" class="year" id="2018" value="2018"> 2018 | <input type="checkbox" class="year" id="2019" value="2019"> 2019

<br/>

 <a href="#" onclick="refresh();"> Aggiorna</a>
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
			error({'error': e});
		       //alert("Impossibile comunicare con il servizio DSS " + e.message);
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
	
	$("body").append('<canvas id="myChart"></canvas>');
		
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
	select.append('<option value="tutti" selected>Tutti</option>');
	
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
	var url = serverUrl + "/modal/api/1.0.0/prestazioniAltreBranche?";
	
	if(min < 5000) // trovato almeno uno
		url += "startdate=01/01/" + min + "&enddate=31/12/" + max + "&";
	
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