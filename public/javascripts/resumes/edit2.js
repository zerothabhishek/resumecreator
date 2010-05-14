


$(document).ready(function(){

	$.ajaxSetup ({ cache: false });
											
	init_data();							// add intial data to the DOM
											// defined in resume_common.js

	empty_box_handler($(".display"));		// all the empty display elements should be replaced 
											// with some dummy characters '--' here	
											// defined in resume_common.js
	
											// Hide all the edit elements and the addPart
	$(".edit").hide();						// only the edit fields- not the entire editParts	
	
	$(".display").each(function() { 			// All the display elements should show linebreaks(<br>) on \n
		display_with_linebreaks($(this)); 		// defined in resume_common.js
	});			


	var displayElements = $(".display");								// Add hover and click eventhandlers to display elements	
	eventHandlers_for_display_elements(displayElements);				// So on hovering, it changes the background-color
																		// and on clicking, it activates the edit functionality	

	var addSubPartButton = $(".new_subpart_button");					// Add evenhandlers to add subpart button
	eventHandlers_for_addSubPart_button(addSubPartButton);				// On a click, it should activate the add new subpart
	
	var addPartButton = $(".addPart_block").find(".addPart_button");		// Add evenhandlers to the addpart button
	eventHandlers_for_addPart_button(addPartButton);						// On a click, it should activate the addPart functionality

	
	var deleteButtons = $(".resume_part").find(".subpart_delete_block > .delete_button");	// Add eventhandlers for delete button
	eventHandlers_for_delete_button(deleteButtons);											// On click, it should delete the "deleteable" item it is within	

//	var deleteables = $(".deleteable");										// hover event on deleteables should show the delete button
//	eventhandler_for_deleteables(deleteables);
	
//	$(".loading_msg_baloon").hide();
//	$("#content").show();
	
	//show_only_one_part();								// if only a part is requested
//	activate_tooltips();	

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
	jObj.click(function(e){ activate_edit(e);});				// should activate its editing 
}
/*****************************************************/
function eventHandlers_for_addSubPart_button(jObj)
{
	var plusButton = jObj;
	plusButton.click(function(e){
		var partBlock = $(e.target).parents(".resume_part").eq(0);
		var plusButton = partBlock.find(".new_subpart_button");
		plusButton.hide();
		activate_addSubPart(partBlock);
	});
	
}

/*****************************************************/
function eventHandlers_for_addPart_button(jObj)
{
	jObj.click(function(e){ 					
			var addPartButton = $(e.target);	
			var addPartBlock = addPartButton.parents(".addPart_block").eq(0);
			var addPartOptionsBlock = addPartBlock.find(".addPart_options").eq(0);		// contains the select input list of part titles that can be created
			var addPartOptions = addPartOptionsBlock.find("OPTION");
			var addPart_submit = addPartBlock.find(".addPart_submit_button").eq(0);
			var existing_parts_titles = $(".resume_part").attr("id");

			addPartOptionsBlock.show();
			addPartOptions.each(function(){
				var this_option = $(this);
				var option_name = this_option.val();
				existing_parts_titles.each(function(){
					if (option_name == $(this).get()){			// if this_option is already present - there is a 
						this_option.hide();						// resume part in its name, remove it from option list - need not be created again
					}	
				});
			});
			
			addPart_submit.show();
			addPart_submit.click(function(e){
				
			});
	});		
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


	