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

  <!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="css/sb-admin.css" rel="stylesheet">

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
          <li class="breadcrumb-item active">Distribuzione eta</li>
        </ol>
      
        <div class="row">
          <div class="col-lg-8">
            <div class="card mb-3">
              <div class="card-header">
                <i class="fas fa-chart-bar"></i>
                Distribuzione et�</div>
              <div class="card-body">
                <canvas id="myBarChart" width="100%" height="50"></canvas>
              </div>
              <div class="card-footer small text-muted">Periodo 2014-2019</div>
            </div>
          </div>
          <div class="col-lg-4">
            <div class="card mb-3">
              <div class="card-header">
                <i class="fas fa-chart-pie"></i>
                Distribuzione et�</div>
              <div class="card-body">
                <canvas id="myPieChart" width="100%" height="100"></canvas>
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
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Page level plugin JavaScript-->
  <script src="vendor/chart.js/Chart.min.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="js/sb-admin.min.js"></script>

  <!-- Demo scripts for this page-->  
  <script>
  Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
  Chart.defaults.global.defaultFontColor = '#292b2c';

  var url = serverUrl + "/modal/api/1.0.0/etaEx"
	
	$.ajax({
	    type: "GET",
		url: url,
		async: false,
		error: function(e) {
			
		    alert("Impossibile comunicare con il servizio" + e.message);
		},
		success: function( response ) {		    		    
		    printChart(response);
		    printPieChart(response);
		}
	});	    	    	      	
  
  function printChart(model)
  {
	  // Bar Chart Example
	  var ctx = document.getElementById("myBarChart");
	  var myLineChart = new Chart(ctx, {
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
	      }
	    }
	  });
  }
  
  function printPieChart(model)
  {
	// Pie Chart Example
	  var ctx = document.getElementById("myPieChart");
	  var myPieChart = new Chart(ctx, {
	    type: 'pie',
	    data: {
	      labels: model.labels,
	      datasets: [{
	        data: model.data[0],
	        backgroundColor: colors
	      }],
	    },
	  });
  }
  </script>

</body>

</html>
