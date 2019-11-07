<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
 
 	<label for="prestazioni-auto">Prestazioni: </label>
  <input id="prestazioni-auto" style="width:200px;">
  <select id="prestazioni" name="groupid" style="width:200px;">
  </select> 
  
  <script type="text/javascript">
  
  $(document).ready(function (){
	  
	  showLoader();
	  $.ajax({
		    type: "GET",
			url: serverUrl + "/modal/api/1.0.0/prestazioni",
			async: true,
			error: function(e) {		
				hideLoader();
			    alert("Impossibile comunicare con il servizio " + e);
			},
			success: function( response ) {		    		    
				addPrestazioni("#prestazioni", response);
				hideLoader();
				refresh();
			}
		});
  
  });
  
function addPrestazioni(id, optionList)
{
	$(id + "-auto").autocomplete({
 	      source: optionList
 	      
 	    });
   	
	$( id + "-auto" ).on( "autocompleteselect", function( event, ui ) {
		
		$(id + " option:selected").prop("selected",false);
		$(id + " option[value='" + ui.item.value + "']")
		        .prop("selected",true);
		
//		$(id + ' option')
//	     .removeAttr('selected')
//	     .filter('[value=' + ui.value + ']')
//	         .attr('selected', true)
		
	     //$(id + " select").val(ui.value);
	     
	     //$(id + ' option[value=' + ui.value+ ']').attr('selected','selected');
	  	
	} );
	
   	var select = $(id);    	
   	//select.append('<option value="none"> &nbsp; </option>');
   	for(var i = 0; i < optionList.length; i++)
   	{
   		var option = optionList[i];
   		select.append('<option value="' + option + '">' + option + '</option>');
   	}
   	
   	
}

</script>
 