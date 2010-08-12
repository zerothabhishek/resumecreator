
$(document).ready(function(){
	
	$.ajaxSetup ({ cache: false });
	$(".achievements_table").find(".achievements_text").each(function(){display_with_linebreaks($(this))});	// address should be displayed with linebreaks

});	