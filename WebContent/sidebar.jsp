<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<ul class="sidebar navbar-nav">
      <li class="nav-item active">
        <a class="nav-link" href="index.jsp">
          <i class="fas fa-fw fa-tachometer-alt"></i>
          <span>Dashboard</span>
        </a>
      </li>    
      <!--   
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <i class="fas fa-fw fa-chart-area"></i>          
          <span>Analisi</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
          <h6 class="dropdown-header">Login Screens:</h6>
          <a class="dropdown-item" href="login.html">Login</a>
          <a class="dropdown-item" href="register.html">Register</a>
          <a class="dropdown-item" href="forgot-password.html">Forgot Password</a>
          <div class="dropdown-divider"></div>
          <h6 class="dropdown-header">Other Pages:</h6>
          <a class="dropdown-item" href="404.html">404 Page</a>
          <a class="dropdown-item" href="blank.html">Blank Page</a>
        </div>
      </li>
       -->
       
      <li class="nav-item active">
        <a class="nav-link" href="eta.jsp#disteta">
          <i class="fas fa-fw fa-chart-bar"></i>
          <span>Distribuzione eta</span></a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="eta.jsp#distetaprest">
          <i class="fas fa-fw fa-chart-bar"></i>
          <span>Prestazioni per eta</span></a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="prestazioni.jsp">
          <i class="fas fa-fw fa-chart-bar"></i>
          <span>Prestazioni per branca</span></a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="prestazionibranche.jsp">
          <i class="fas fa-fw fa-braille"></i>
          <span>Bubble Prestazioni-branche</span></a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="prestazioni.jsp#presteta">
          <i class="fas fa-fw fa-chart-bar"></i>
          <span>Età per prestazioni</span></a>
      </li>
      <li class="nav-item active">
        <a class="nav-link" href="attesa.jsp">
          <i class="fas fa-fw fa-chart-bar"></i>
          <span>Attesa per branca</span></a>
      </li>
      <li class="nav-item active dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <i class="fas fa-fw fa-fire"></i>          
          <span>Heatmaps</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
          <a class="dropdown-item" href="hmBranche.jsp">Branche</a>
          <a class="dropdown-item" href="hmPrestazioni.jsp">Prestazioni</a>
        </div>
      </li>
      <li class="nav-item active dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <i class="fas fa-fw fa-th-large"></i>          
          <span>Treemaps</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
          <a class="dropdown-item" href="tmBranchePrestazioni.jsp">Branche/Prestazioni</a>
          <a class="dropdown-item" href="tmEtaPrestazioni.jsp">Eta/Prestazioni</a>
        </div>
      </li>
      <li class="nav-item active dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <i class="fas fa-fw fa-chart-line"></i>          
          <span>Path nel tempo</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
          <a class="dropdown-item" href="paths.jsp?type=rgraph">r-graph</a>
          <a class="dropdown-item" href="paths.jsp?type=hypertree">hypertree</a>
          <a class="dropdown-item" href="paths.jsp?type=icycle">iCycle</a>
          <a class="dropdown-item" href="paths.jsp?type=sunburst">sunburst</a>
          <a class="dropdown-item" href="paths.jsp?type=hypertree">spacetree</a>
        </div>
      </li>
      <!-- 
      <li class="nav-item">
        <a class="nav-link" href="tables.html">
          <i class="fas fa-fw fa-table"></i>
          <span>Tables</span></a>
      </li>
      -->
    </ul>
