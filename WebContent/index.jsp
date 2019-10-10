<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- drawer.css -->
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/drawer/3.2.2/css/drawer.min.css">
<!-- jquery & iScroll -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/iScroll/5.2.0/iscroll.min.js"></script>
<!-- drawer.js -->
<script src="http://cdnjs.cloudflare.com/ajax/libs/drawer/3.2.2/js/drawer.min.js"></script>
<title>CUP WEB</title>
</head>
<body class="drawer drawer--left">
<%@include file="header.jsp" %>
<main role="main" style="margin: 100px;">
<h1>MODAL@DMA</h1>
<h2>CUP BI</h2>
<hR>
<a href="branche.jsp">Prestazioni per branca (barre)</a><br/><br/>
<a href="brancheTorta.jsp">Prestazioni per branca (torta)</a><br/><br/>
<a href="attesa.jsp">Giorni di attesa per branca</a><br/><br/>
<a href="bubble.jsp">Prestazioni per branca per comune (bubble)</a></br><br/>
<a href="prestazioniTorta.jsp">Tipo Prestazioni(torta)</a><br/><br/>
<a href="heatmapPrestazioni.jsp">Heatmap Prestazioni</a><br/><br/>
<a href="heatmapBranche.jsp">Heatmap Branche</a><br/><br/>
<a href="prenotazionePerBrancaDopoBranca.jsp">Prenotazione Per Branca Dopo Branca</a><br/><br/>
<a href="prenotazionePerPrestazioneDopoPrestazione.jsp">Prenotazione Per Prestazione Dopo Prestazione</a><br/><br/>
<a href="treemapBranchePrestazioni.jsp">Treemap branche prestazioni</a><br/><br/>
<a href="pathPrestazioniNelTempo.jsp">Path prestazioni nel tempo (icycle)</a><br/><br/>
<a href="graphpathPrestazioniNelTempo.jsp">Path prestazioni nel tempo (rgraph)</a><br/><br/>
<a href="sunburstPathPrestazioniNelTempo.jsp">Path prestazioni nel tempo (sunburst)</a><br/><br/>
<a href="hypertreePrestazioniNelTempo.jsp">Path prestazioni nel tempo (hypertree)</a><br/><br/>
<a href="spacetreePrestazioniNelTempo.jsp">Path prestazioni nel tempo (spacetree)</a><br/><br/>


<a href="etaPrestazioni.jsp">eta per prestazione</a><br/><br/>
<a href="prestazioniEta.jsp">prestazioni per eta</a><br/><br/>
<a href="prestazioniAltreBranche.jsp">prestazioni AltreBranche</a><br/><br/>
<a href="bubblePrestazioni.jsp">prestazioni non residenti per uop (bubble)</a><br/><br/>

</main>
</body>
</html>