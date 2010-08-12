var bgColor;

$(document).ready(function(){
	
	$.ajaxSetup ({ cache: false });
	$("#content > #heading").find(".resume_title").addClass("current_item");	// highlight the page name in heading
	
	init_data();
	$("p").each(function(){display_with_linebreaks($(this));});
	activate_tabs();

	$(".addPart").hide();								// the eventhandlers
	$("#publish").find(".setting_action").click(function(e){ change_public_status(e) });		
	$("#delete_resume").find(".setting_action").click(function(e){ delete_resume(e) });
	$("#templates").find(".set_button > button").bind("click",function(e){ set_rtemplate(e); });	
	$("#resume_parts").find(".plus_button > button").bind("click", function(e){ add_resume_part(e) });

	activate_tooltips();
	activate_dropDownMenu();							// show the menu

	$(".loading_msg_baloon").hide();						// hide the baloon that says 'Loading'
	$("#content").show();									// the partcontainer is hidden until this point
});

//********* activate tabs ***********/
function activate_tabs()
{
	// Add the click and hover event handlers to the tab buttons
	// show one (requested or default tab)
	
	var all_tab_buttons = $(".tab_button");
	var all_tab_items = $(".tab_item");
	
	$(".tab_button").bind("click", function(e){ 
			var tab_item_id = '#'+$(e.target).attr("id").split('-')[0];
			show_tab_item(tab_item_id); 
	});

	var bgColor = $("#tab_bar").css("background-color");
	$(".tab_button").hover(
			function(){ $(this).addClass("hover_tab_button");},
			function(){ $(this).removeClass("hover_tab_button");}
	);
	
	var default_tab_item_id = '#'+all_tab_items.filter(":first").attr("id");		// first tab item is the default
	var tab_item_id = window.location.hash || default_tab_item_id;					// the part after the # in the url, including the # symbol
	show_tab_item(tab_item_id);						
}

function show_tab_item(active_tab_item_id)
{
	var all_tab_items = $(".tab_item");
	var all_tab_buttons = $(".tab_button");

	var active_tab_item = all_tab_items.filter(active_tab_item_id);
	var active_tab_button_id = active_tab_item_id+'-tab_button';
	var active_tab_button = all_tab_buttons.filter(active_tab_button_id);

	all_tab_items.hide();
	active_tab_item.show();

	all_tab_buttons.removeClass("active_tab_button").addClass("inactive_tab_button");
	active_tab_button.removeClass("inactive_tab_button").addClass("active_tab_button");

}

//********* add_resume_part ***********/
function add_resume_part(e)
{
	// show the addPart and hide the plus button
	var plusButton = $(e.target);
	var partBlock = plusButton.parents(".part").eq(0);
	var addPartBlock = partBlock.find(".addPart").eq(0);
	addPartBlock.show("slow");
	plusButton.hide();

	addPartBlock.find(".delete_button").eq(0).hide();	// hide the delete button
	
													// show and add the button_stripe
	var button_stripe = $(".button_stripe").filter(".hidden").clone();
	button_stripe.removeClass("hidden");
	button_stripe.css("display","inline");
	addPartBlock.append(button_stripe);
	
	// add eventhandler to update and clear buttons
	var button_stripe = addPartBlock.find(".button_stripe").eq(0);
	button_stripe.find(".update").bind("click",	function(e){ 
					update_resume_part(e);
	});
	button_stripe.find(".clear").bind("click",	function(e){ 
					addPartBlock.hide("slow");
					addPartBlock.find(".button_stripe").remove();
					plusButton.show();
	});
}

function update_resume_part(e)
{
	var updateButton = $(e.target);
	var addPartBlock = updateButton.parents(".addPart").eq(0);
	var postUrl = updateButton.parents(".part").eq(0).data("addUrl");
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var postData = new Object();			//  hash for the post-data
		
	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	addPartBlock.find(".add").each(function(){
		postData[$(this).attr('name')] = $(this).val();
	});
	
	$.post(
		postUrl,
		postData,
		function(response){
			update_resume_part_callback(e, response);
		}
	);	
}

function update_resume_part_callback(e, response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "created"){
		$.jGrowl(responseObj["retVal"]);
		return;
	}
	
	var updateButton = $(e.target);

	// hide the add part
	var addPartBlock = updateButton.parents(".addPart").eq(0);
	addPartBlock.hide("slow");
	
	// hide the plus button and display the tick mark
	var partBlock = updateButton.parents(".part").eq(0);
	var plus_button = partBlock.find(".plus_button").eq(0);
	var tick_mark = partBlock.find(".tick_mark").eq(0);
	plus_button.addClass("hidden");		// hides it
	tick_mark.removeClass("hidden");	// shows it
	
	// remove the button stripe
	addPartBlock.find(".button_stripe").remove();
}

//********* set rtemplates ***********/
function set_rtemplate(e)
{
	var setButton = $(e.target);
	var targetBlock = setButton.parents(".rtemplate_item").eq(0);
	var targetId = targetBlock.attr("id").split("_")[1];			// its id is rtemplate_<id>
	
	var resume_title = window.location.pathname.split("/")[2];				// third part on splitting /options/:title at '/'
	var postUrl = '/set_rtemplates'
	var postData = new Object();

	postData["authenticity_token"] = $("*[name='authenticity_token']").eq(0).val();;
	postData["ajax"]="true";
	postData["title"] = resume_title;
	postData["rtemplate_id"] = targetId;
	
	$.post(
			postUrl,
			postData,
			function(response){
				set_rtemplate_callback(e,response);
			}
	);
}
function set_rtemplate_callback(e, response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "set"){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;	
	}	
	
	var prev_set_block = $("#rtemplates_block").find(".current").eq(0);
	var new_set_block = $(e.target).parents(".rtemplate_item").eq(0);

	// interchange the  classes on prev and new set blocks
	prev_set_block.removeClass("current");
	new_set_block.addClass("current");
	
	// interchange the tick mark - show it in the new one and hide it from the old one
	new_set_block.find(".tick_mark").removeClass("hidden");		// removeClass("hidden") = show()
	prev_set_block.find(".tick_mark").addClass("hidden");		// addClass("hidden") = hide()
	
	// interchange the set button - show it in the old one, and hide it from the new one
	new_set_block.find(".set_button").addClass("hidden");
	prev_set_block.find(".set_button").removeClass("hidden");
}

//********* change public status ***********/
function change_public_status(e)
{
	var resume_id, authToken;
	var postUrl, postData = new Object();
	
	authToken = $("*[name='authenticity_token']").eq(0).val();
	resume_id = $(e.target).parents('.all_container').eq(0).attr('id').split('_')[1];	// the container has id - resumeId_<id>
	postUrl = '/toggle_public_status';
	postData["resume_id"] = resume_id
	postData["authenticity_token"] = authToken;
	postData["ajax"] = "true";
	postData["request"] = "toggle";
	
	$.post(
		postUrl,
		postData,
		function(response){
			change_public_status_callback(e, response);
		});
}
function change_public_status_callback(e, response)
{
	var responseObj = JSON.parse(response);
	
	if (responseObj["retVal"] == "error"){
		$.jGrowl("Error");
		return;
	}
	
	var publish_block = $(e.target).parents("#publish").eq(0);
	
	// change the status text
	publish_block.find(".public_status_text").html(responseObj["public_status"]);	
	
	// show/hide the public URL if the new status is public/private
	if (responseObj["public_status"]=='public'){
		publish_block.find(".public_url_info").show();
	}
	if (responseObj["public_status"]=='private'){
		publish_block.find(".public_url_info").hide();
	}
}

//********* set as default ***********/
function set_resume_as_default(e)
{
	var resume_id;
	var postUrl, postData = new Object();

	resume_id = $(e.target).parents('.container').eq(0).attr('id').split('_')[1];	// the container has id - resumeId_<id>	
	postUrl = '/set_default_resume';
	postData["authenticity_token"] = $("*[name='authenticity_token']").eq(0).val();
	postData["ajax"] = "true";
	postData["resume_id"] = resume_id;
	
	$.post(
		postUrl,
		postData,
		function(response){
			set_as_default_callback(e, response);
		});
}
function set_as_default_callback(e, response)
{
	var responseObj = JSON.parse(response);
	
	if (responseObj["retVal"] != "set"){
		$.jGrowl(responseObj["retVal"]);
	}	
	$(e.target).parents("#default_status").find(".default_status_text").filter(".hidden").eq(0).removeClass("hidden");
	$(e.target).parents(".default_status_text").eq(0).addClass("hidden");
	
}

//********* delete resume ***********/
function delete_resume(e)
{
	if (!confirm("Sure?"))	{	return	}

	var title = window.location.pathname.split("/")[2];			// third part on splitting /show/:title/rtemplates at '/'
	var postUrl = '/destroy/'+title;
	var postData = new Object();

	postData["authenticity_token"] = $("*[name='authenticity_token']").eq(0).val();
	postData["ajax"] = "true";
	
	$.post(
		postUrl,
		postData,
		function(response){
			var responseObj = JSON.parse(response);
			if (responseObj["retVal"] != "deleted"){
					$.jGrowl(responseObj["retVal"]);
			}
			window.location.replace("/home");	// redirect to the  user's home page, replace done so this page doesn't show up in history
		});
}

//********* activate tooltips ***********/
function activate_tooltips()
{
	// for all tick marks
	$(".tick_mark > .tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
							edgeOffset:10, 
							defaultPosition:"right", 
							delay:100, 
							maxWidth: "10em", 
							content: tooltip_html
						});	
	});
	
	// for all plus buttons
	$(".plus_button").filter(".tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
							activation: "hover",
							edgeOffset:10, 
							defaultPosition:"right", 
							delay:100, 
							maxWidth: "10em", 
							content: tooltip_html
						});	
	});

	// for all buttons
	$("BUTTON").filter(".tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
							edgeOffset:10, 
							defaultPosition:"right", 
							delay:100, 
							maxWidth: "10em", 
							content: tooltip_html
						});	
	});
	
	// for rtemplate thumbnail
	$(".thumbnail > .tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
							activation: "hover",
							edgeOffset:10, 
							defaultPosition:"right", 
							delay:100, 
							maxWidth: "10em", 
							content: tooltip_html
						});	
	});
	
	// for all input boxes within addPart(s)
	$(".addPart").find(".tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
							activation: "focus",
							defaultPosition: "right", 
							delay: 100, 
							maxWidth: "auto", 
							content: tooltip_html
						});	
	});
}