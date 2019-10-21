<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="js/constants.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0/dist/Chart.min.js"></script>	
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-colorschemes"></script>
<meta charset="ISO-8859-1">
<title>Bar Chart</title>
</head>
<body>

<span class="ui-widget">MinValue: <input id="minValue" value="0"  style="width:80px;"></span>
<%@include file="headerComuni.jsp" %>

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

$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/prestazioniPerBranca",
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
	
	var total = 0;
	var valuesHashMap = { };

	for(var i = 0; i < count; i++)
	{
		var red   = Math.sin(frequency*i+2+phase) * amplitude + center;
	    var green = Math.sin(frequency*i+0+phase) * amplitude + center;
	    var blue  = Math.sin(frequency*i+4+phase) * amplitude + center;
	    
		//var color = 20 + i * 2;
		backgroundColorArray.push('rgba(' + red + ', ' + green+ ', ' + blue + ', 0.2)');
		
		total += model.data[0][i];
		
		valuesHashMap[model.labels[i]] = model.data[0][i];
	}
	
	if(myChart != null)
	{
		$("#myChart").remove();		
	}
	
	var h = $(document).height();
	var w = $("body").width();
	$("body").append('<canvas id="myChart" width="' + w + '" height="' + h + '"></canvas>');		
	
	var ctx = document.getElementById('myChart').getContext('2d');
	myChart = new Chart(ctx, {
    	type: 'bar',
    	data: {
	        labels: model.labels,
	        datasets: [{
	            //label: '# di prestazioni per branca',
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
	    	plugins: {
	            colorschemes: {
	                scheme: 'brewer.Paired12'
	            }
	        },
	        legend: {
	        	display: false,
	        	label: 
	        		{
	        		
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
	        },
	        tooltips: {
	            // Disable the on-canvas tooltip
	            enabled: false,

	            custom: function(tooltipModel) {
	                // Tooltip Element
	                var tooltipEl = document.getElementById('chartjs-tooltip');

	                // Create element on first render
	                if (!tooltipEl) {
	                    tooltipEl = document.createElement('div');
	                    tooltipEl.id = 'chartjs-tooltip';
	                    tooltipEl.innerHTML = '<table></table>';
	                    document.body.appendChild(tooltipEl);
	                }

	                // Hide if no tooltip
	                if (tooltipModel.opacity === 0) {
	                    tooltipEl.style.opacity = 0;
	                    return;
	                }

	                // Set caret Position
	                tooltipEl.classList.remove('above', 'below', 'no-transform');
	                if (tooltipModel.yAlign) {
	                    tooltipEl.classList.add(tooltipModel.yAlign);
	                } else {
	                    tooltipEl.classList.add('no-transform');
	                }

	                function getBody(bodyItem) {
	                    return bodyItem.lines;
	                }

	                // Set Text
	                if (tooltipModel.body) {
	                    var titleLines = tooltipModel.title || [];
	                    var bodyLines = tooltipModel.body.map(getBody);

	                    var innerHtml = '<thead>';

	                    titleLines.forEach(function(title) {
	                        innerHtml += '<tr><th>' + title + '</th></tr>';
	                    });
	                    innerHtml += '</thead><tbody>';

	                    bodyLines.forEach(function(body, i) {
	                        var colors = tooltipModel.labelColors[i];
	                        var style = 'background:#DDD';// + colors.backgroundColor;
	                        style += '; border-color:' + colors.borderColor;
	                        style += '; border-width: 2px';
	                        var span = '<span style="' + style + '"></span>';
	                        var perc = (valuesHashMap[titleLines[0]] / total * 100);
	                        innerHtml += '<tr><td>' + span + body + '</td></tr></tr><tr><td>' + perc.toFixed(2) + '%</td></tr><tr><td>Totale: ' + total + '</td>';
	                    });
	                    innerHtml += '</tbody>';

	                    var tableRoot = tooltipEl.querySelector('table');
	                    tableRoot.innerHTML = innerHtml;
	                }

	                // `this` will be the overall tooltip
	                var position = this._chart.canvas.getBoundingClientRect();

	                // Display, position, and set styles for font
	                tooltipEl.style.opacity = 1;
	                tooltipEl.style.position = 'absolute';
	                tooltipEl.style.left = position.left + window.pageXOffset + tooltipModel.caretX + 'px';
	                tooltipEl.style.top = position.top + window.pageYOffset + tooltipModel.caretY + 'px';
	                tooltipEl.style.fontFamily = tooltipModel._bodyFontFamily;
	                tooltipEl.style.fontSize = tooltipModel.bodyFontSize + 'px';
	                tooltipEl.style.fontStyle = tooltipModel._bodyFontStyle;
	                tooltipEl.style.padding = tooltipModel.yPadding + 'px ' + tooltipModel.xPadding + 'px';
	                tooltipEl.style.pointerEvents = 'none';
	                tooltipEl.style.backgroundColor = "#DDD";
	            }
	        }
	    }
	});
	
	//$("#myChart").css("height", "700px");
	
	//myChart.canvas.parentNode.style.height = '300px';	
	//myChart.canvas.parentNode.style.width = '128px';
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
	
	var comune = $('#comuni-auto').val();
	if(comune == ""  || comune == undefined)
		comune = $('#comuni').find(":selected").text();
	
	var url = serverUrl + "/modal/api/1.0.0/prestazioniPerBranca?";
	
	if(min < 5000) // trovato almeno uno
		url += "startdate=01/01/" + min + "&enddate=31/12/" + max + "&";
	
	//if(branca != "Tutti")
	//	url += "branca=" + branca + "&";
	
	if(comune != "Tutti")
		url += "comune=" + comune;
					
	url += "&minValue=" + $('#minValue').val();
	
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