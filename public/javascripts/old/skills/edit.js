
$(document).ready(function(){

	$.ajaxSetup ({ cache: false });	
	$(".heading").eq(0).width($(".skills_table").eq(0).width());	// set the width of the heading = width of table
	
});	
