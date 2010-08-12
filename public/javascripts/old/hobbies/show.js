
$(document).ready(function(){
	
	$.ajaxSetup ({ cache: false });
	$(".hobbies_table").find(".hobbies_text").each(function(){display_with_linebreaks($(this))});	// address should be displayed with linebreaks

});	