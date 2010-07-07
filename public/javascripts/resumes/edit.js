

$(document).ready(function(){

	$.ajaxSetup ({ cache: false });
	all_functionality();

});

/*****************************************************/
function all_functionality()
{
	var usernameElement = $("#username");									// make the username editable		
	usernameElement.find(".edit").hide();
	eventHandlers_for_display_elements(usernameElement.find(".display"));

	var parts = $(".resume_part");
	parts.each(function(){	part_functionality($(this));	});				// functionality within each of the parts

	var addPartButton = $("#addPart_block").find(".addPart_button");		// Add evenhandlers to the addpart button
	eventHandlers_for_addPart_button(addPartButton);						// On a click, it should activate the addPart functionality		
}

/*****************************************************/
function part_functionality(thisPart)
{
	var partHeader = thisPart.find(".part_header");						// make the part header also editable
	partHeader.find(".edit").hide();
	eventHandlers_for_display_elements(partHeader.find(".display"));
	
	var subparts = thisPart.find(".resume_subpart");
	subparts.each(function(){	subpart_functionality($(this));	});		// functionality to each subpart within the part
		
	var addSubPartButton = thisPart.find(".new_subpart_button");		// Add evenhandlers to add subpart button
	eventHandlers_for_addSubPart_button(addSubPartButton);				// On a click, it should activate the add new subpart
}

/*****************************************************/
function subpart_functionality(thisSubpart)
{
	var editElements = thisSubpart.find(".edit");
	editElements.hide();												// hide all the edit elements
		
	var displayElements = thisSubpart.find(".display");					// various functionality for display elements
	eventHandlers_for_display_elements(displayElements);				// empty_box_handler, display_with_linebreaks, hover, click

	var deleteButtons = thisSubpart.find(".subpart_delete_block > .delete_button");		// Add eventhandlers for delete button
	eventHandlers_for_delete_button(deleteButtons);										// On click, it should delete the "deleteable" item it is within
}

/*****************************************************/
function eventHandlers_for_display_elements(displayElements)
{
	empty_box_handler(displayElements);					// fill all the empty display elements with a '--'
	display_with_linebreaks(displayElements);			// introduce linebreaks in displayelements
	
	var bgColor = displayElements.css("background-color");			// Hover on display elements should change the element background color
	displayElements.hover(	
				function(){ $(this).css({"background-color":"#ABABFF", "cursor":"default"})},
				function(){ $(this).css({"background-color":bgColor, "cursor":"auto"})}		);
																 
	displayElements.click(function(e){ activate_edit(e);});		// click on the display element should activate its editing 
}
/*****************************************************/
function eventHandlers_for_addSubPart_button(jObj)
{
	var plusButton = jObj;
	plusButton.click(function(e){
		var partBlock = $(e.target).parents(".resume_part").eq(0);
		var plusButton = partBlock.find(".new_subpart_button");
		plusButton.hide();

		var partId = partBlock.attr("id").split("_")[1];		// part block has id like - "contact_45"		
		var url = "/create/subpart";						
		var params = new Object();
		params["partId"] = partId;
		params["ajax"] = "true";
		$.get(	url, 
				params,
				function(response){	addSubPart_callback(e,response); },
				"html"		// expected type							
				);	
	});
	
}

function addSubPart_callback(e, response)
{
	if (response == "error"){
		$.jGrowl("Some error occurred");				// XXX: Change this action to something better
		return;			
	}
		
	var addSubPart_button = $(e.target);
	var part_block = addSubPart_button.parents(".resume_part").eq(0);
	var partData_block = $(".part_data", part_block);
	
	partData_block.append(response);
	
	var newlyAddedSubPart = $(".resume_subpart:last", partData_block);
	subpart_functionality(newlyAddedSubPart);					// add eventhandlers and other functionality to the new part
	
	addSubPart_button.show();									// show the hidden "add more <subpart>" button
}
/*****************************************************/
function eventHandlers_for_addPart_button(jObj)
{
	jObj.toggle(
		function(e){ 					
			var addPartButton = $(e.target);	
			var addPartBlock = addPartButton.parents(".addPart_block").eq(0);
			var addPartOptionsBlock = addPartBlock.find(".addPart_options").eq(0);		// contains the select input list of part titles that can be created
			var addPartOptions = addPartOptionsBlock.find("OPTION");
			var addPart_submit = addPartBlock.find(".addPart_submit_button").eq(0);
			var existing_parts_titles = $(".resume_part").attr("id");

			addPartButton.html("Cancel");
			addPartOptionsBlock.show();
			addPart_submit.show();
			
			addPart_submit.click(function(e){	post_addPartRequest(e);	});
		},
		function(e){
			var addPartButton = $(e.target);	
			var addPartBlock = addPartButton.parents(".addPart_block").eq(0);
			var addPartOptionsBlock = addPartBlock.find(".addPart_options").eq(0);		// contains the select input list of part titles that can be created			
			var addPart_submit = addPartBlock.find(".addPart_submit_button").eq(0);
			
			addPartButton.html("Add new Part");
			addPartOptionsBlock.hide();
			addPart_submit.hide();			
		}
	);		
}
function post_addPartRequest(e)
{
	var addPart_submitButton = $(e.target);
	var addPartBlock = addPart_submitButton.parents(".addPart_block").eq(0);
	var selectTag = addPartBlock.find("SELECT").eq(0);
	
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var postUrl = "/create2/part"
	var postData = new Object();
			
	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	postData[selectTag.attr("name")] = selectTag.val();
	
	$.post(
		postUrl,
		postData,
		function(response){
			callback_addPartRequest(e, response)
	});
}

function callback_addPartRequest(e, response)
{
	// The response is HTMl. This HTML has to be embedded into the DOM within the all parts block

	if (response=="error"){
		$.jGrowl("Some error occurred");				// XXX: Change this action to something better
		return;	
	}
		
	var allParts_block = $("#all_parts");
	allParts_block.append(response);
	
	var newlyAddedPart = $(".resume_part:last", allParts_block);
	part_functionality(newlyAddedPart);					// add eventhandlers and other functionality to the new part
}


/*****************************************************/
function eventHandlers_for_delete_button(jObj)
{	
																// jObj is Jquery object for all delete buttons	
	jObj.click(function(e){										// click on the delete button 
			delete_the_subpart(e);								// should delete the subpart it is within	
	});	
}
/*****************************************************/
function eventhandler_for_deleteables(jObj)
{
	var deleteables = jObj;										// whenever a deleteable is hovered upon, 
	deleteables.hover(											// the delete button is shown
		function(e){	$(this).find(".delete_button").css({"visibility" : "visible"});	},
		function(e){	$(this).find(".delete_button").css({"visibility" : "hidden"});	}
	);
}

/*****************************************************/
function activate_tooltips()
{
	// for all plus buttons
	$(".plus_button > .tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
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

/*****************************************************/
	