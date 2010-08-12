
$(document).ready(function(){

	$.ajaxSetup ({ cache: false });
	$("#content > .heading").find(".new_resume_button").addClass("current_item");	// highlight the page name in heading

	//activate_create();
	activate_tooltips();
	activate_validators();
	deactivate_create_button();		// activated only when user enters valid input
	show_errors();
});


/*
function activate_create()
{
	var create_button = $("#new_resume_block").find(".create_button").eq(0);
	
	create_button.click(function(e){	send_create_request(e);	});
}

function send_create_request(e){
	
	var postUrl = '/create';
	var postData = new Object();
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var all_inputs = $("#new_resume_block").find(".value_item > .input");
		
	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	all_inputs.each(function(){
		postData[$(this).attr('name')] = $(this).val();
	});
	
	var ajaxMsgObj = $("#new_resume_block").find(".create_button_block > .ajax_processing_msg").eq(0);
	ajaxMsgObj.show();
	
	$.post(
			postUrl,
			postData,
			function (response){ 
				create_callback(response);
			}
	)		
}
function create_callback(response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "created"){
		$.jGrowl(responseObj["retVal"], { sticky: true });	
		return;	
	}
	
	var resume_title = responseObj["title"];				// of the newly created resume
	var part_by_part_link = "/qedit/"+resume_title+"/contacts";
	var single_go_link = "/qedit/"+resume_title;
		
	var done_msg_block = $("#content").find("#done_msg");
	var part_by_part_span = done_msg_block.find(".part-by-part");
	var single_go_span = done_msg_block.find(".single-go");
	
	part_by_part_span.html("<a href=" +part_by_part_link+ ">" +part_by_part_span.html()+ "</a>");
	single_go_span.html("<a href=" +single_go_link+ ">" +single_go_span.html()+ "</a>");
	
	
	var ajaxMsgObj = $("#new_resume_block").find(".create_button_block > .ajax_processing_msg").eq(0);
	ajaxMsgObj.hide();

	done_msg_block.show();
}
*/


function activate_tooltips()
{

	// for all input boxes
	$(".tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
							activation: "focus",
							defaultPosition: "right", 
							delay: 100, 
							maxWidth: "15em", 
							content: tooltip_html
						});	
	});
	
}

function activate_validators()
{
	// validate the resume title
	var titleObj = $("#new_resume_block").find("[name='resume[title]']").eq(0);
	titleObj.blur(function(e){
		valid = validate_inputs("resume_title", $(this));
		if(!valid){
			$.jGrowl("resume title is invalid");
			deactivate_create_button();
			}else{
			activate_create_button();	}
	});	
}
function deactivate_create_button()
{
	// just changes the visibility - replaces the real one with the dummy button
	var create_button = $("#new_resume_block").find(".create_button").eq(0);
	var dummy_create_button = $("#new_resume_block").find(".dummy_submit").eq(0);
	
	create_button.hide();
	dummy_create_button.show();	
}
function activate_create_button()
{	
	// just changes the visibility - replaces the dummy button with the real one
	var create_button = $("#new_resume_block").find(".create_button").eq(0);
	var dummy_create_button = $("#new_resume_block").find(".dummy_submit").eq(0);
	
	create_button.show();
	dummy_create_button.hide();		
}


function show_errors()
{
	var error_msg_div = $("#error_msg");
	if (error_msg_div.html() == ""){	return;	}
	$.jGrowl(error_msg_div.html(), { sticky: true, position: 'center' });
}