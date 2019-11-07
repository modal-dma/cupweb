<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="../js/constants.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0/dist/Chart.min.js"></script>	
<script src="../js/widgetLoader.js"></script>

<meta charset="ISO-8859-1">
 <!-- Custom fonts for this template-->
  <link href="../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="../vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
 
 <link rel="stylesheet" href="../css/style.css">

<title>Bar Chart</title>
</head>
<body>
<div class="menubar">
<span class="ui-widget">
<%@include file="widgetAnni.jsp" %>
<%@include file="widgetAsl.jsp" %>
<a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>
</span>
</div>
<!-- 
<div class="chart-container" style="position: relative; height:80vh; width:90vw">
 -->
<!-- </div>  -->
<script>

var urlParams = new URLSearchParams(location.search);
var type = urlParams.get('type');  

var myChart = null;

var method = type == "disp" ? "attesaDisponibilitaPerBranca" : "attesaPerBranca";

$(document).ready(function () {
	showLoader();

	$.ajax({
		    type: "GET",
			url: serverUrl + "/modal/api/1.0.0/" + method,
			async: true,
			error: function(e) {
				hideLoader();
			    alert("Impossibile comunicare con il servizio " + e.message);
			},
			success: function( response ) {		    		  
				hideLoader();
			    printChart(response);
			}
		});
	
});	
	
function printChart(model)
{
	var color = Chart.helpers.color;
	
	if(myChart != null)
	{
		$("#myChart").remove();		
	}
	
	var total = 0;
	
	for(var i = 0; i < model.data[3].length; i++)
	{
		total += model.data[3][i];	
	}
	
	var h = $(document).height() - 40;
	var w = $("body").width();
	$("body").append('<canvas id="myChart" width="' + w + '" height="' + h + '"></canvas>');	
	
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
	                        
	                        innerHtml += '<tr><td>' + span + body + '</td></tr></tr><tr><td>Totale: ' + total + '</td>';
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
	
	myChart.canvas.parentNode.style.height = '300px';
	//myChart.canvas.parentNode.style.width = '128px';
}

function RGB2Color(r,g,b, a)
{
  return 'rgba(' + 20 + ', ' + color + ', ' + color + ', 0.2)';
}

function refresh()
{
	showLoader();
	
	var anni = parseInt($('#anni').find(":selected").attr("value"));
    var annoPartenza = parseInt($('#annoPartenza').find(":selected").attr("value"));
    
    var annoFine = annoPartenza + anni;
    
//	var comune = $('#comuni-auto').val();
//	if(comune == ""  || comune == undefined)
//		comune = $('#comuni').find(":selected").text();
	
	var url = serverUrl + "/modal/api/1.0.0/" + method + "?";
	
	url += "startdate=01/01/" + annoPartenza + "&enddate=31/12/" + annoFine + "&";
	
	var asl = $('#asl').find(":selected").text();
	
	if(asl != "Tutte")
		url += "asl=" + asl;
	
//	if(comune != "Tutti")
//		url += "comune=" + comune;
		
	
	$.ajax({
	    type: "GET",
		url: url,
		async: true,
		error: function(e) {
			hideLoader();
		    alert("Impossibile comunicare con il servizio " + e.message);
		},
		success: function( response ) {		    		  
			hideLoader();
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