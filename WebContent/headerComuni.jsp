<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
 <span class="ui-widget" >
 <input type="checkbox" class="year" id="2013" value="2013"> 2013 | <input type="checkbox" class="year" id="2014" value="2014"> 2014 | <input type="checkbox" class="year" id="2015" value="2015"> 2015 | <input type="checkbox" class="year" id="2016" value="2016"> 2016 | <input type="checkbox" class="year" id="2017" value="2017"> 2017 | <input type="checkbox" class="year" id="2018" value="2018"> 2018 | <input type="checkbox" class="year" id="2019" value="2019"> 2019
 <label for="comuni-auto">Comuni: </label>
 <input id="comuni-auto" style="width:300px;">
 <select id="comuni" name="groupid" style="width:100px;">
</select> 

 <a href="#" onclick="refresh();"> Aggiorna</a>
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