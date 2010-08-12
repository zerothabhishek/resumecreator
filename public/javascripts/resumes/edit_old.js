


$(document).ready(function(){

	$.ajaxSetup ({ cache: false });
											
	init_data();							// add intial data to the DOM
											// defined in resume_common.js

	empty_box_handler($(".display"));		// all the empty display elements should be replaced 
											// with some dummy characters '--' here	
											// defined in resume_common.js
	
											// Hide all the edit elements and the addPart
	$(".edit").hide();						// only the edit fields- not the entire editParts	
	$(".addPart").hide();					// the entire addParts
	$(".part_footer").hide();				// all the part_footers
	
	$(".display").each(function() { 			// All the display elements should show linebreaks(<br>) on \n
		display_with_linebreaks($(this)); 		// defined in resume_common.js
	});			


	var displayElements = $(".resume_part").find(".display");			// Add hover and click eventhandlers to display elements	
	eventHandlers_for_display_elements(displayElements);				// So on hovering, it changes the background-color
																		// and on clicking, it activates the edit functionality	
	
	var plusButton = $(".resume_part").find(".plus_button > BUTTON");		// Add evenhandlers to plus button
	eventHandlers_for_addPart_button(plusButton);							// On a click, it should activate the addPart functionality

	
	var deleteButton = $(".resume_part").find(".delete_button > BUTTON");	// Add eventhandlers for delete button
	eventHandlers_for_delete_button(deleteButton);							// On click, it should delete the "deleteable" item it is within	

	var deleteables = $(".deleteable");										// hover event on deleteables should show the delete button
	eventhandler_for_deleteables(deleteables);
	
	$(".loading_msg_baloon").hide();
	$("#content").show();
	
	//show_only_one_part();								// if only a part is requested
	activate_tooltips();	

	//activate_dropDownMenu();							// show the menu
});


/*****************************************************/
function eventHandlers_for_display_elements(jObj)
{
														// Hover on display elements should 
	var bgColor = jObj.css("background-color");			// change the element background color
	jObj.hover(
			function(){ $(this).css({"background-color":"#ABABFF", "cursor":"default"})},
			function(){ $(this).css({"background-color":bgColor, "cursor":"auto"})}
	);
																// click on the display element 
	jObj.bind("click", function(e){ activate_edit(e);});		// should activate its editing 
}
/*****************************************************/
function eventHandlers_for_addPart_button(jObj)
{
	var plusButton = jObj;												// jObj - jquery object for plusButton
	plusButton.bind("click", function(e){ 								// click on the plusButton 	
			var plusButton	= $(e.target).parent(".plus_button");		// hide the plusButton
			var partBlock = plusButton.parents(".resume_part").eq(0);
			plusButton.hide();
			activate_addPart(partBlock);								// should show the addPart for adding the parts data
	});		
}
/*****************************************************/
function eventHandlers_for_delete_button(jObj)
{																// jObj is Jquery object for all delete buttons	
	jObj.bind("click", function(e){								// click on the delete button 
			delete_the_deleteable(e);							// should delete the deleteable part it is within	
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
/*
function show_only_one_part()
{
	var partName = window.location.pathname.split("/")[3];			// :part in /qedit/:title/:part - third index	
	var partId = "#"+partName;	
	var allResumeParts = $(".resume_part");
	var partObj	= allResumeParts.filter(partId);					// its one among the resume_part
	
	if (partObj.length==0){											// there is no part by that name or part is not requested
		return;
	}	
	
	// hide all and show the necessary
	allResumeParts.hide();											// hide all the parts
	partObj.show();													// show only the one requested	
	
	// if the part has no content, show the corresponding addpart
	var editPart = partObj.find(".editPart").eq(0);
	var display_elements_in_editPart = editPart.find(".display");
	if (display_elements_in_editPart.length == 0){					// there are no display_elements_in_editPart, editPart is empty
		partObj.find(".plus_button").hide();						// hide the add button
		activate_addPart(partObj);		
	}
	
	// show the part footer
	//partObj.find(".part_footer").show();
}
*/
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


	