
$(document).ready(function(){
	
	$.ajaxSetup ({ cache: false });
	$(".contact_table").find(".address").each(function(){display_with_linebreaks($(this))});	// address should be displayed with linebreaks

});	