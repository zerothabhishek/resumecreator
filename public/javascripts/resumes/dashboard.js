
$(document).ready(function(){
	$.ajaxSetup ({ cache: false });
	
	$("#content > .heading").find(".dashboard_link").addClass("current_item");		// highlight the page name in heading
});

