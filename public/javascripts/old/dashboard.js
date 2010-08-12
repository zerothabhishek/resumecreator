
$(document).ready(function(){
	$.ajaxSetup ({ cache: false });
	
	$("#content > .heading").find(".dashboard_link").addClass("current_item");		// highlight the page name in heading
	
	//activate_help();	
});

function activate_help()
{
	var help_activator = $("#help_activator");
	help_activator.click(function(){show_help()});
		
	$("#help_block").find(".hide_activator").click(function(){
		var help_block = $("#help_block");
		help_block.removeClass("help_block_class");		
		help_block.hide();

		var help_activator = $("#help_activator");
		help_activator.show();
	});
}
function show_help()
{
	var help_activator = $("#help_activator");
	help_activator.hide();
	
	var help_block = $("#help_block");
	help_block.addClass("help_block_class");
	help_block.show("slow");
}
