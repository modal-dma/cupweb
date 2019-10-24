<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">





<script>
$(document).ready(function() {
	$(document.body).addClass("drawer drawer--left")
  	$('.drawer').drawer();
});
</script>

<header role="banner">
    <button type="button" class="drawer-toggle drawer-hamburger">
      <span class="sr-only">toggle navigation</span>
      <span class="drawer-hamburger-icon"></span>
    </button>
    <nav class="drawer-nav" role="navigation">
      <ul class="drawer-menu">
       <li><a class="drawer-brand" href="#">Grafici Disponibili</a></li>
      	<li><a class="drawer-menu-item" href="branche.jsp">Prestazioni per branca (barre)</a></li>
		<li><a class="drawer-menu-item" href="brancheTorta.jsp">Prestazioni per branca (torta)</a></li>
		<li><a class="drawer-menu-item" href="attesa.jsp">Giorni di attesa per branca</a></li>
		<li><a class="drawer-menu-item" href="bubble.jsp">Prestazioni per branca per comune (bubble)</a></li>
		<li><a class="drawer-menu-item" href="prestazioniTorta.jsp">Tipo Prestazioni(torta)</a></li>
		<li><a class="drawer-menu-item" href="heatmapPrestazioni.jsp">Heatmap Prestazioni</a></li>
		<li><a class="drawer-menu-item" href="heatmapBranche.jsp">Heatmap Branche</a></li>
		<li><a class="drawer-menu-item" href="prenotazionePerBrancaDopoBranca.jsp">Prenotazione Per Branca Dopo Branca</a></li>
		<li><a class="drawer-menu-item" href="prenotazionePerPrestazioneDopoPrestazione.jsp">Prenotazione Per Prestazione Dopo Prestazione</a></li>
		<li><a class="drawer-menu-item" href="treemapBranchePrestazioni.jsp">Treemap branche prestazioni</a></li>
		<li><a class="drawer-menu-item" href="pathPrestazioniNelTempo.jsp">Path prestazioni nel tempo (icycle)</a></li>
		<li><a class="drawer-menu-item" href="graphpathPrestazioniNelTempo.jsp">Path prestazioni nel tempo (rgraph)</a></li>
		<li><a class="drawer-menu-item" href="sunburstPathPrestazioniNelTempo.jsp">Path prestazioni nel tempo (sunburst)</a></li>
         
      </ul>
    </nav>
  </header>
  