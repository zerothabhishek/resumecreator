$(document).ready(function(){

	$.ajaxSetup ({ cache: false });

											
	init_data();							// add intial data to the DOM
											// defined in resume_common.js

	empty_box_handler($(".display"));		// all the empty display elements should be replaced 
											// with some dummy characters '--' here	
											// defined in resume_common.js
	
											// Hide all the edit elements and the addPart
	$(".edit").hide();						// only the edit fields- not the entire editPart	
	$(".addPart").hide();					// the entire editPart
	
	$(".display").each(function() { 			// All the display elements should show linebreaks(<br>) on \n
		display_with_linebreaks($(this)); 		// defined in resume_common.js
	});			


	var displayElements = $(".part").find(".display");					// Add hover and click eventhandlers to display elements	
	eventHandlers_for_display_elements(displayElements);				// So on hovering, it changes the background-color
																		// and on clicking, it activates the edit functionality	
	
	var plusButton = $(".part").find(".plus_button > BUTTON").eq(0);		// Add evenhandlers to plus button
	eventHandlers_for_addPart_button(plusButton);							// On a click, it should activate the addPart functionality

	
	var deleteButton = $(".part").find(".delete_button > BUTTON");			// Add eventhandlers for delete button
	eventHandlers_for_delete_button(deleteButton);							// On click, it should delete the "deleteable" item it is within	
	
	$(".loading_msg_baloon").hide();						// hide the baloon that says 'Loading'
	$(".parts_container").removeClass("hidden");			// the partcontainer is hidden until this point
});

/*****************************************************/	
function eventHandlers_for_display_elements(jObj)
{
	// Hover on display elements should change the element background color
	bodyBgColor = $("BODY").css("background-color");
	jObj.hover(
			function(){ $(this).css({"background-color":"#ABABFF", "cursor":"default"})},
			function(){ $(this).css({"background-color":bodyBgColor, "cursor":"auto"})}
	);
	// click on the display element should activate the editing
	jObj.bind("click", function(e){ activate_edit_hobby(e);});				
}
function activate_edit_hobby(e)
{
	activate_edit(e);					// defined in resume_common.js
}

/*****************************************************/
function eventHandlers_for_addPart_button(jObj)			
{
	var plusButton = jObj;				// jObj - jquery object for plusButton
	
	plusButton.bind("click", function(e){ 
			activate_addPart_hobby(e);
	});	
}
function activate_addPart_hobby(e)
{	
	activate_addPart(e);				// defined in resume_common.js	
}

/*****************************************************/
function eventHandlers_for_delete_button(jObj)
{
	jObj.bind("click", function(e){		// jObj is Jquery object for all delte buttons	
			delete_the_deleteable_hobby(e);
	});
}

function delete_the_deleteable_hobby(e)
{
	delete_the_deleteable(e);
}