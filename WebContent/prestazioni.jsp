<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>CUP-iONE - BI Dashboard</title>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	
  <!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="css/sb-admin.css" rel="stylesheet">
  
  <link rel="stylesheet" href="css/style.css">

</head>

<body id="page-top">

<%@include file="navbar.jsp" %>


  <div id="wrapper">

    <!-- Sidebar -->
    <%@include file="sidebar.jsp" %>
    <div id="content-wrapper">

      <div class="container-fluid">

        <!-- Breadcrumbs-->
        <ol class="breadcrumb">
          <li class="breadcrumb-item">
            <a href="#">Dashboard</a>
          </li>
          <li class="breadcrumb-item active">Distribuzione Prestazioni</li>
        </ol>
      
        <div class="row">
          <div class="col-lg-8">
            <div class="card mb-3">
              <div class="card-header">
                <i class="fas fa-chart-bar"></i>
                Distribuzione Prestazioni - Totale: <span id="total"></span></div>
              <div class="card-body graph">
              <div class="menubar">
              <span class="ui-widget">
			    Mostra le prime: <input id="limit" value="20"  style="width:40px;">
			    <%@include file="graphs/widgetAnni.jsp" %>
			    <%@include file="graphs/widgetAsl.jsp" %>
			 	<br/>
			 	<label for="comuni-auto">Comuni: </label>
 				<input id="comuni-auto" style="width:300px;">&nbsp;
 				<select id="comuni" name="groupid" style="width:150px;">
				</select> 
			 			
			 <a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>
			 </span>               
			 </div> 
              </div>
              <div class="card-footer small text-muted">Periodo 2014-2019</div>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="card mb-3">
              <div class="card-header">
                <i class="fas fa-chart-pie"></i>
                Distribuzione Prestazioni</div>
              <div class="card-body pie">
                
              </div>
              <div class="card-footer small text-muted">Periodo 2014-2019</div>
            </div>
          </div>
        </div>
      </div>
      <!-- /.container-fluid -->

      <!-- Sticky Footer -->
      <%@include file="footer.jsp" %>

    </div>
    <!-- /.content-wrapper -->

  </div>
  <!-- /#wrapper -->

  <!-- Scroll to Top Button-->
  <a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>

  <!-- Logout Modal-->
  <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
          <button class="close" type="button" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
        <div class="modal-footer">
          <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
          <a class="btn btn-primary" href="login.html">Logout</a>
        </div>
      </div>
    </div>
  </div>

<script src="js/constants.js"></script>

  <!-- Bootstrap core JavaScript-->
  
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Page level plugin JavaScript-->
  <script src="vendor/chart.js/Chart.min.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="js/sb-admin.min.js"></script>

<script src="js/widgetLoaderMain.js"></script>

  <!-- Demo scripts for this page-->  
  <script>
  Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
  Chart.defaults.global.defaultFontColor = '#292b2c';

  var methodUrl = serverUrl + "/modal/api/1.0.0/tipoPrestazioni?limit=";
  
$(document).ready(function() {
		
	showLoader();
	
	$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/comuni",
		async: true,
		error: function(e) {
			hideLoader();
		    alert("Impossibile comunicare con il servizio" + e.message);
		},
		success: function( response ) {
			hideLoader();
			addComuni("#comuni", response);
			
			refresh();
		}
	});		
});

function refresh()
{
	showLoader();
		
	var url = methodUrl + $('#limit').val();
	
	var anni = parseInt($('#anni').find(":selected").attr("value"));
    var annoPartenza = parseInt($('#annoPartenza').find(":selected").attr("value"));
    
    var annoFine = annoPartenza + anni;
    
    url += "&startdate=01/01/" + annoPartenza + "&enddate=31/12/" + annoFine;
    
	var comune = $('#comuni-auto').val();
	if(comune == ""  || comune == undefined)
		comune = $('#comuni').find(":selected").text();

	if(comune != "Tutti")
		url += "&comune=" + comune;

	var asl = $('#asl').find(":selected").text();
	
	if(asl != "Tutte")
		url += "&asl=" + asl;
	
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
			calculateTotal(response);
		    printChart(response);
		    printPieChart(response);
		}
	});
};
		    
  function addComuni(id, optionList)
  {
  	$(id + "-auto").autocomplete({
       source: optionList
     });
  	
  	var select = $(id);    	     	
  	select.append('<option value="tutti" selected>Tutti</option>');
  	for(var i = 0; i < optionList.length; i++)
  	{
  		var option = optionList[i];
  		select.append('<option value="' + option + '">' + option + '</option>');
  	}
  	
	$( id + "-auto" ).on( "autocompleteselect", function( event, ui ) {
		
		$(id + " option:selected").prop("selected",false);
		$(id + " option[value='" + ui.item.value + "']")
		        .prop("selected",true);
	});
  }
  
  var valuesHashMap = { };
  var total;
  function calculateTotal(model)
  {
	  total = 0;
	  for(var i = 0; i < model.data[0].length; i++)
	  {
		  total += model.data[0][i];
		  valuesHashMap[model.labels[i]] = model.data[0][i];
		  valuesHashMap[model.labels[i] + ": " + model.data[0][i]] = model.data[0][i];
	  }
	  
	  $('#total').text('' + total);
	  
  }
  
  var myLineChart;
  function printChart(model)
  {
	  if(myLineChart != null)
		{
			$("#myBarChart").remove();		
		}
	  
	  $(".graph").append('<canvas id="myBarChart" width="100%" height="70" style="margin-top: 10px"></canvas>');
	  
	  // Bar Chart Example
	  var ctx = document.getElementById("myBarChart");
	  myLineChart = new Chart(ctx, {
	    type: 'bar',
	    data: {
	      labels: model.labels,
	      datasets: [{
	        label: "Prestazioni:",
	        backgroundColor: colors,
	        borderColor: "rgba(2,117,216,1)",
	        data: model.data[0]
	      }],
	    },
	    options: {
	      scales: {
	        xAxes: [{
	          gridLines: {
	            display: false
	          }	          
	        }],
	        yAxes: [{
	          ticks: {
	            maxTicksLimit: 5
	          },
	          gridLines: {
	            display: true
	          }
	        }],
	      },
	      legend: {
	        display: false
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
  }
  
  var myPieChart;
  
  function printPieChart(model)
  {
	  if(myPieChart != null)
		{
			$("#myPieChart").remove();		
		}
	  
	  $(".pie").append('<canvas id="myPieChart" width="100%" height="100" style="margin-top: 10px"></canvas>');
	  
	// Pie Chart Example
	  var ctx = document.getElementById("myPieChart");
	  myPieChart = new Chart(ctx, {
	    type: 'pie',
	    data: {
	      labels: model.labels,
	      datasets: [{
	        data: model.data[0],
	        backgroundColor: colors,
	        label: "Prestazioni:"
	      }],
	    },
	    options: {
	    	legend: {
		        display: false
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
		                        var perc = (valuesHashMap[bodyLines[0]] / total * 100);
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
  }
  </script>

</body>

</html>
