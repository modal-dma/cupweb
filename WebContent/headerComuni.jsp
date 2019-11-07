<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

 <!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
 
 <link rel="stylesheet" href="css/style.css">
 
 <span style="background-color: white; text-align: right;">
 <span class="ui-widget">
    MinValue: <input id="minValue" value="0"  style="width:80px;">
    <%@include file="graphs/widgetAnni.jsp" %>
 	<%@include file="graphs/widgetComuni.jsp" %>

 <a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>
 </span>
 </span>
    
 <script src="js/widgetLoader.js"></script>
     