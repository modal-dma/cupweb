<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="css/style.css">

 <label for="comuni-auto">Comuni: </label>
 <input id="comuni-auto" style="width:300px;">&nbsp;
 <select id="comuni" name="groupid" style="width:100px;">
</select> 

<script>
     
$(document).ready(function() {
	
	$("#ajaxloader").show();
	
	$.ajax({
	    type: "GET",
		url: serverUrl + "/modal/api/1.0.0/comuni",
		async: true,
		error: function(e) {
			$("#ajaxloader").hide();
		    alert("Impossibile comunicare con il servizio" + e.message);
		},
		success: function( response ) {
			$("#ajaxloader").hide();
			addComuni("#comuni", response);
		}
	});	
});

function addComuni(id, optionList)
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