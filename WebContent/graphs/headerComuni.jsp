<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

 <!-- Custom fonts for this template-->
  <link href="../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="../vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
 
 <link rel="stylesheet" href="../css/style.css">
 
 <div class="menubar">
 <span class="ui-widget">
    MinValue: <input id="minValue" value="0"  style="width:80px;">
    <%@include file="widgetAsl.jsp" %>
    <%@include file="widgetAnni.jsp" %>
 	<%@include file="widgetComuni.jsp" %>

 <a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>
 </span>
 </div>
    
 <script src="../js/widgetLoader.js"></script>
     