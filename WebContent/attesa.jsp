<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0/dist/Chart.min.js"></script>	
<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>
<input type="checkbox" class="year" id="2013" value="2013"> 2013 | <input type="checkbox" class="year" id="2014" value="2014"> 2014 | <input type="checkbox" class="year" id="2015" value="2015"> 2015 | <input type="checkbox" class="year" id="2016" value="2016"> 2016 | <input type="checkbox" class="year" id="2017" value="2017"> 2017 | <input type="checkbox" class="year" id="2018" value="2018"> 2018 | <input type="checkbox" class="year" id="2019" value="2019"> 2019

<br/>
<select id="comuni" name="groupid" style="width:100%;">

</select> 
<br/>

<a href="#" onclick="refresh();"> Aggiorna</a>
<!-- 
<div class="chart-container" style="position: relative; height:80vh; width:90vw">
 -->
<!-- </div>  -->
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
		addOptions("#comuni", response);
	}
});

var urlParams = new URLSearchParams(location.search);
var type = urlParams.get('type');  

var myChart = null;

var method = type == "disp" ? "attesaDisponibilitaPerBranca" : "attesaPerBranca";
$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/" + method,
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
	var color = Chart.helpers.color;
	
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
	            label: 'Min gg di attesa',
	            data: model.data[0],	            
	            backgroundColor: 'rgba(255, 99, 132, 1)',
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
	        }, 
	        {
	            label: 'Max gg di attesa',
	            data: model.data[1],
	            backgroundColor: 'rgba(54, 162, 235, 1)',	            
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
	        }, 
	        {
	            label: 'Media gg di attesa',
	            data: model.data[2],	            
	            backgroundColor: 'rgba(153, 102, 255, 1)',
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
	    	aspectRatio: 4/3,
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
	
	//var branca = $('#branche').find(":selected").text();
	var comune = $('#comuni').find(":selected").text();
	
	var url = serverUrl + "/modal/api/1.0.0/" + method + "?";
	
	if(min < 5000) // trovato almeno uno
		url += "startdate=01/01/" + min + "&enddate=31/12/" + max + "&";
	
	//if(branca != "Tutti")
	//	url += "branca=" + branca + "&";
	
	if(comune != "Tutti")
		url += "comune=" + comune;
	
	
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

/*
var count = model.data.length;
var backgroundColorArray = [];

var frequency = .3;
var amplitude = 127;
var center = 128;
var phase = 128;
for(var i = 0; i < count; i++)
{
	red   = Math.sin(frequency*i+2+phase) * width + center;
    green = Math.sin(frequency*i+0+phase) * width + center;
    blue  = Math.sin(frequency*i+4+phase) * width + center;

    
	backgroundColorArray.push('rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)');
	
	   // Note that &#9608; is a unicode character that makes a solid block
	   document.write( '<font style="color:' + RGB2Color(v,v,v) + '">&#9608;</font>');
	}
	
	var color = 20 + i * 2;

}
*/
</script>

</body>
</html>