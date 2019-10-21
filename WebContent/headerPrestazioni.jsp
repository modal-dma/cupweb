<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<span style="background-color: white; text-align: center;">
  <span class="ui-widget" >
  <label for="prestazioni-auto">Prestazioni: </label>
  <input id="prestazioni-auto" style="width:200px;">
  <select id="prestazioni" name="groupid" style="width:200px;">
</select> 
      
   	 Sesso:<select id="gender" name="gender" style="width:70px;">    
      <option value='0'>Tutti</option>
      <option value='1'>Maschio</option>
      <option value='2'>Femmina</option>
      </select>
      Anno:<select id="annoPartenza" name="annoPartenza" style="width:60px;">    
      <option value='2014'>2014</option>
      <option value='2015'>2015</option>
      <option value='2016'>2016</option>
      <option value='2017'>2017</option>
      <option value='2018'>2018</option>
      <option value='2019'>2019</option>
      </select>
      Durata anni:<select id="anni" name="anni" style="width:40px;">         
      <option value='1'>1</option>
      <option value='2'>2</option>
      <option value='3'>3</option>
      <option value='4'>4</option>
      <option value='5'>5</option>
      </select>
      Eta:<select id="eta" name="eta" style="width:65px;">         
      <option value='0-14'>0-14</option>
      <option value='15-30'>15-30</option>
      <option value='30-40'>30-40</option>
      <option value='40-50'>40-50</option>
      <option value='50-60'>50-60</option>
      <option value='60-70'>60-70</option>
      <option value='70-90'>70-90</option>            
      <option value='>90'>>90</option>
      <option value='tutti'>Tutti</option>      
      </select>
      Limite:<input type="text" id="userLimit" id="userLimit" value="10000" style="width:60px"/>
     	<a href="#" onclick="refresh();"> Aggiorna</a>
     	</span>
     </span>   
     
     <script>
     function addOptions(id, optionList)
     {
     	$(id + "-auto").autocomplete({
   	      source: optionList
   	    });
     	
     	var select = $(id);    	
     	select.append('<option value="none"> &nbsp; </option>');
     	for(var i = 0; i < optionList.length; i++)
     	{
     		var option = optionList[i];
     		select.append('<option value="' + option + '">' + option + '</option>');
     	}
     	
     }
     </script>