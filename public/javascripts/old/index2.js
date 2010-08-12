var bgColor;

$(document).ready(function(){
	
	$.ajaxSetup ({ cache: false });
	
	activate_actions_buttons();
});

function activate_actions_buttons()
{
	var action_buttons = $(".actions").find(".myButton");
	action_buttons.hover( 				
				function(){ $(this).css({"border":"1px solid black", "cursor":"default"})},
				function(){ $(this).css({"border":"0", "cursor":"auto"})}
	);
	action_buttons.bind("click", function(e){ 
		hide_displayed_content(e);
		show_hidden_block(e);
	} );
}

function hide_displayed_content(e)
{
	$("#content > .about_box").hide("slow");
	$("#content > .login_form").hide("slow");
	$("#content > .actions").hide("slow");
}	

function show_hidden_block(e)
{
	var actionButton = $(e.target);
	var actionBlockName = actionButton.attr("id").split("_")[0]+"_block";		// tour_button => tour_block
	var actionBlock = $('#'+actionBlockName);

	actionBlock.show("slow");
	
	var backButton = $("#hidden_blocks").find(".back_button");
	backButton.show();
	backButton.bind("click", function(e){
		backButton.hide();
		actionBlock.hide();
		$("#content > .about_box").show("slow");
		$("#content > .login_form").show("slow");
		$("#content > .actions").show("slow");
	});
}