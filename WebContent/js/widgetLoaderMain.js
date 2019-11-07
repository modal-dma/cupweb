

$(document).ready(function () {
	$(document.body).append('<div id="spinner-front"><img src="images/Wedges-3s-200px.gif"/></div><div id="spinner-back"></div>');	
});
	
function showLoader () {
	  document.getElementById("spinner-front").classList.add("show");
	  document.getElementById("spinner-back").classList.add("show");
};

function hideLoader () {
  document.getElementById("spinner-front").classList.remove("show");
  document.getElementById("spinner-back").classList.remove("show");
};
