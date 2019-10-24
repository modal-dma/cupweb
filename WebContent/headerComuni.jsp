<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
 <!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
 
 <link rel="stylesheet" href="css/style.css">
 
 <span style="background-color: white; text-align: right;">
 <span class="ui-widget">
    MinValue: <input id="minValue" value="0"  style="width:80px;">
 	Anno: <select id="annoPartenza" name="annoPartenza" style="width:60px;">    
      <option value='2014'>2014</option>
      <option value='2015'>2015</option>
      <option value='2016'>2016</option>
      <option value='2017'>2017</option>
      <option value='2018'>2018</option>
      <option value='2019'>2019</option>
      </select>
      Durata anni: <select id="anni" name="anni" style="width:40px;">         
      <option value='1'>1</option>
      <option value='2'>2</option>
      <option value='3'>3</option>
      <option value='4'>4</option>
      <option value='5'>5</option>
      </select>
 <label for="comuni-auto">Comuni: </label>
 <input id="comuni-auto" style="width:300px;">&nbsp;
 <select id="comuni" name="groupid" style="width:100px;">
</select> 

 <a href="#" onclick="refresh();"><i class="fas fa-sync-alt"></i></a>
 </span>
 </span>
     <script>
     function addOptions(id, optionList)
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
     	
     }
     </script>