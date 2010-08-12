
function init_data()
{
	// the data is urls of the actions where the updates should be posted
	var pathArray = window.location.pathname.split("/");	// To get the title and part from the URL path (/edit2/:title/education)
	var title = pathArray[2];								// third index [2] in the array
	$("#username").data("updateUrl","/update/"+title);
	$("#contacts").data("updateUrl","/update/"+title+"/contacts");
	$("#profiles").data("updateUrl","/update/"+title+"/profiles");
	$("#skills").data("updateUrl","/update/"+title+"/skills");
	$("#educations").data("updateUrl","/update/"+title+"/educations");
	$("#experiences").data("updateUrl","/update/"+title+"/experiences");
	$("#achievements").data("updateUrl","/update/"+title+"/achievements");
	$("#hobbies").data("updateUrl","/update/"+title+"/hobbies");
	
	// the data is the urls of the actions where the add requests should be sent
	$("#contacts").data("addUrl","/create/"+title+"/contacts");
	$("#profiles").data("addUrl","/create/"+title+"/profiles");
	$("#skills").data("addUrl", "/create/"+title+"/skills");
	$("#educations").data("addUrl","/create/"+title+"/educations");
	$("#experiences").data("addUrl","/create/"+title+"/experiences");
	$("#achievements").data("addUrl","/create/"+title+"/achievements");
	$("#hobbies").data("addUrl","/create/"+title+"/hobbies");
	
	// the data is the parturls of the actions where the delete requests should be sent
	// /destroy/<part>/<id>
	$("#contacts").data("deleteUrl","/destroy/"+title+"/contacts");
	$("#profiles").data("deleteUrl","/destroy/"+title+"/profiles");
	$("#skills").data("deleteUrl", "/destroy/"+title+"/skills/");
	$("#educations").data("deleteUrl","/destroy/"+title+"/educations/");
	$("#experiences").data("deleteUrl","/destroy/"+title+"/experiences/");
	$("#achievements").data("deleteUrl","/destroy/"+title+"/achievements");
	$("#hobbies").data("deleteUrl","/destroy/"+title+"/hobbies");
}

/*****************************************************/

function activate_edit(e)
{
	var displayElement = $(e.target);
	var editElement = displayElement.siblings(".edit").eq(0);	
	var height = displayElement.height();
	var width = displayElement.width();
	var font_size = displayElement.css("font-size");					// e.g - 16px
	var font_width = font_size.slice(0,(font_size.indexOf('px')));		// e.g - 16
	var min_width;
	
	// hide the display element clicked and show the corresponding edit element
	displayElement.hide();
	editElement.show();
	
	//set the edit element's size
	if(editElement.get(0).tagName=='TEXTAREA'){		
		min_width = 30*font_width;	
		height = 4*height;
	}else{										
		min_width = 20*font_width;
		height = 1.2*height;
	}	
	if (width < min_width)	{ width = min_width; }
	editElement.css({"height":height,"width":width});
		
	
	// show and add the button_stripe
	var button_stripe = $(".button_stripe").filter(".hidden").clone();
	button_stripe.removeClass("hidden");
	button_stripe.addClass("button_stripe_active");
	editElement.after(button_stripe);
	
	// add event handlers (for update and cancel and hover) to the button stripe
	button_stripe.find(".update").bind("click",function(e){ update_the_edited(e) });
	button_stripe.find(".clear").bind("click", function(e){ deactivate_edit(e) });

}

function update_the_edited(e)
{
	var button_stripe = $(e.target).parents(".button_stripe").eq(0);	// the target element is the button span - update button
	var editElement = button_stripe.siblings(".edit").eq(0);
	var displayElement = button_stripe.siblings(".display").eq(0);
	var editElementName = editElement.attr("name");
	var editElementValue = editElement.val();
	
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var postData = new Object();		// creating the hash for the post-data
	var postUrl = "/update2"
		
	postData[editElementName] = editElementValue;
	postData["authenticity_token"] = authToken;
	postData["ajax"] = "true";

	var ajaxMsgObj = button_stripe.find(".ajax_processing_msg");
	ajaxMsgObj.show();
	
	$.post(
			postUrl,
			postData,
			function (response){ 
				ajaxMsgObj.hide();				
				update_the_edited_callback(e, response);
			}
	)	
}

function update_the_edited_callback(e, response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "updated"){
		$.jGrowl(responseObj["retVal"], { sticky: true });	
		return;	
	}
	
	var button_stripe = $(e.target).parents(".button_stripe").eq(0);
	var displayElement = button_stripe.siblings(".display").eq(0);
	var editElement = button_stripe.siblings(".edit").eq(0);
	var editElementValue = editElement.val();
	
	displayElement.html(editElementValue);		// the display element now holds the new value
	
	display_with_linebreaks(displayElement);	// the display element should, again, present its contents with linebreaks
	empty_box_handler(displayElement);			// if the display element is empty, replace it with '--'

	deactivate_edit(e);							// the editelement should be deactivated now
}

function deactivate_edit(e)
{
	var button_stripe = $(e.target).parents(".button_stripe").eq(0);	// the target element is the clear button span
	button_stripe.siblings(".edit").hide();
	button_stripe.siblings(".display").show();
	button_stripe.remove();												// remove the button from the dom
}	


/*****************************************************/

function activate_addPart(partBlock)
{

	var addPart = partBlock.find(".addPart").eq(0);				
	addPart.show("slow");											// show the addPart
	
	addPart.find(".delete_button").eq(0).hide();	// hide the delete button within the addpart
		
													// show and add the button_stripe
	var button_stripe = $(".button_stripe").filter(".hidden").clone();
	button_stripe.removeClass("hidden");
	button_stripe.addClass("button_stripe_active");
	addPart.append(button_stripe);
													// add eventhandlers to the button stripe
	button_stripe.find(".update").bind("click",	function(e){ update_the_added(e) ;});		// for update
	button_stripe.find(".clear").bind("click", 	function(e){ deactivate_addPart(e) ;});		// for clear	
	button_stripe.find("span").hover(														// for hover	
			function(){ $(this).css({"border":"1px solid black", "cursor":"default"})},
			function(){ $(this).css({"border":"0", "cursor":"auto"})}
	);	

}

function update_the_added(e)
{
	var updateButton = $(e.target);
	var button_stripe = updateButton.parents(".button_stripe").eq(0);
	var addPartBlock = updateButton.parents(".addPart").eq(0);
	var postUrl = updateButton.parents(".resume_part").eq(0).data("addUrl");
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var postData = new Object();			
		
	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	addPartBlock.find(".add").each(function(){
		postData[$(this).attr('name')] = $(this).val();
	});
	
	var ajaxMsgObj = button_stripe.find(".ajax_processing_msg");
	ajaxMsgObj.show();
	
	$.post(
		postUrl,
		postData,
		function(response){
			ajaxMsgObj.hide();
			update_the_added_callback(e, response);
		}
	);	
}

function update_the_added_callback(e, response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "created"){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;	
	}

	var id = responseObj["id"];								// the id of created object as returned
		
	var updateButton = $(e.target);
	var partBlock = updateButton.parents(".resume_part").eq(0);
	var addPartBlock = partBlock.find(".addPart").eq(0);	
	var addPartClone = addPartBlock.clone(true);						// keep a clone of the addPart
	
	
	addPartBlock.find(".add").each(function(){							// Change the addPart into an editPart		
		var addElement = $(this);
		

		
		var partName = partBlock.attr("id");								// skip this step for singleton parts- contacts, profiles, achievements, hobbies
		if (partName=="experiences" || partName=="educations" || partName=="skills")
		{																	// only for multivalued parts (skills, educations, experiences)
																			// change the element's name - include the name		
			var nameParts = splitName($(this).attr("name"));				// eg- split education[major] into
			var partName  = nameParts[0];									//			education
			var fieldName = nameParts[1];									//			major
			var nameStr = partName+'['+id+']['+fieldName+']';				//  	education[<id>][major]
			addElement.attr('name',nameStr);								
		}
		
		var innerHTML = addElement.val() || addElement.html();			// insert the data 
		var displayElement = addElement.siblings(".display").eq(0);		//  from the boxes of the addElement 
		displayElement.html(innerHTML);									// 	to the displayElement	
		addElement.removeClass("add");									// remove the className "add"
		addElement.addClass("edit");									// add the className "edit"
		displayElement.removeClass("hidden");							// show the displayElement
		addElement.addClass("hidden");									// hide the addElement
		display_with_linebreaks(displayElement);						// the displayElement should show linebreaks
	});
	
	addPartBlock.removeClass("addPart");								// Change the classNames of addPartBlock
	addPartBlock.addClass("partUnit");									// to convert it to editPart			
	addPartBlock.addClass("deleteable");								// remove "addPart", add "partUnit" and  "deleteable"	
	eventhandler_for_deleteables(addPartBlock);							// add eventhandlers for the new part (activate the delete button)
	
	addPartBlock.find(".button_stripe").remove();						// remove the button_stripe	
	addPartBlock.find(".delete_button").show();							// show the delete button

	empty_box_handler(addPartBlock.find(".display"));					// if any of the display elements in addPartBlock is empty, replace it with '--'
	
	var newId = partBlock.attr("id") + '_' + id ;						// Get it an id - <part's id attribute>_<id of created object>
	addPartBlock.attr("id",newId);										//	eg- education_<id>

	var editPart = partBlock.find(".editPart").eq(0);					// insert the changed addPart
	editPart.append(addPartBlock);										// within the editPart
	
	
														
															// addPartClone is a copy of the original addPart
	var partDataElement = partBlock.find(".part_data");		// addPart appears as the last element within the partData element
	partDataElement.append(addPartClone);					// insert addPart there	
	addPartClone.find(".add").val('');						// nullify all its input fields
	addPartClone.find(".button_stripe").remove();			// remove the button_stripe	from the clone
	
	addPartClone.hide();											// hide the addPart
	
	var partName = partBlock.attr("id");
	if (partName=="experiences" || partName=="educations" || partName=="skills")
	{																	// show the old plus button			
		var plusButton = partBlock.find(".plus_button").eq(0);			// onyl for multipart elements - experiences, educations, skills
		plusButton.show();
	}
	
	// if its a part-request (/canvas/:title/:part) : show the footer
	//var partNameInUrl = window.location.pathname.split("/")[3];			// :part in /canvas/:title/:part - third index
	//if (partNameInUrl==""){	return 	}									// its not a part-request
	//var partFooter = partBlock.find(".part_footer").eq(0);
	//partFooter.show();
	
}

function deactivate_addPart(e)
{
	var clearButton = $(e.target);
	var partBlock = clearButton.parents(".resume_part").eq(0);
	var plusButton	= partBlock.find(".plus_button").eq(0);				
	plusButton.show();													// show the plusButton	

	var button_stripe = clearButton.parents(".button_stripe").eq(0);	// the target element is the clear button span
	button_stripe.remove();												// remove the button from the dom

	var addPart = partBlock.find(".addPart").eq(0);						// hide the addPart
	addPart.hide("slow");	
	
}


/*****************************************************/
	
function delete_the_subpart(e)
{
	var deleteButton = $(e.target);
	var deleteable = deleteButton.parents(".resume_subpart").eq(0);
	var deleteable_id = deleteable.attr("id").split("_")[1];			// second part of the id.
	
	var postUrl = "/destroy/subpart"
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var postData = new Object();		
		
	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	postData["id"] = deleteable_id;
	
	var ajaxMsgObj = $(".button_stripe").filter(".hidden").find(".ajax_processing_msg").clone();
	deleteButton.append(ajaxMsgObj);
	ajaxMsgObj.show();
	
	$.post(			
		postUrl,	
		postData,
		function(response){	
			ajaxMsgObj.hide();
			delete_the_subpart_callback(e,response); 
		}
	);	
}
function delete_the_subpart_callback(e, response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "deleted"	){
		$.jGrowl(responseObj["retVal"]);								// XXX: Change this action to something better
		return;
	}	
	
	var deleteButton = $(e.target);										// Its the delete_button > BUTTON
	var subpartBlock = deleteButton.parents(".resume_subpart").eq(0);
	var partBlock = deleteButton.parents(".resume_part").eq(0);

	var deleteable = subpartBlock;
	deleteable.hide("slow");											// hide the deleteable slowly
	deleteable.remove();												// remove the deleteable element	
	
	var num_subparts_left = partBlock.find(".resume_subpart").length;
	if (num_subparts_left==0){					// If there are no subparts left, remove the part block,
		partBlock.remove();						// the server will remove the corresponding object
	}
}


/*****************************************************/
function activate_dropDownMenu()
{
	
	var actionMenu = $("#heading > #menu").eq(0);
	var menuHeader = actionMenu.find(".menu_header");
	
	menuHeader.toggle(	function(){
							var menuItems_block = $(this).siblings(".menu_items").eq(0);
							menuItems_block.slideDown("fast");
							$(this).addClass("menu_header_click");
						},
						function(){
							var menuItems_block = $(this).siblings(".menu_items").eq(0);							
							menuItems_block.slideUp("fast");
							$(this).removeClass("menu_header_click");
						}	
	);
	
	menuHeader.hover(	function(){	$(this).addClass("menu_header_hover");	},
						function(){	$(this).removeClass("menu_header_hover");	}
	);
	
	var menuItem = actionMenu.find(".menu_item");
	menuItem.hover(		function(){	$(this).addClass("menu_item_hover");	}, 
						function(){	$(this).removeClass("menu_item_hover");	}
	);
}


/*****************************************************/
function fake_delete(e)					// dummy function - only for manual testing
{
	$(e.target).css("border","2px solid green");
	$.jGrowl($(e.target).parents("tr").filter(":first").html());

	$(e.target).parents("tr").filter(":first").css("background-color","red");	
	$(e.target).parents("tr").filter(":first").remove();	
}

function delete_it(e)
{
	// Usage - 
	//	delete_it(eventObject, [resumeTitle], [resumePart])
	// 	eg - delete_it(e,2,skills)	or 		delete_it(e)
	// What does this do ?
	// 	Gets the current resume's title and the part under consideration from the URL (or from the arguements)
	// 	Sends an AJAX post request to delete the delteable object (represented by e)
	// 	If the reponse is positive, removes the DOM table row that contains the deleteable object

	var postId = $(e.target).attr("id");							// id of the item's row to be deleted	
	var pathArray = window.location.pathname.split("/")				// To get the title and part from the URL path (/show/:title/education)
	var title = arguments[1] || pathArray[2];						// second arguement passed (if present) OR third index [2] in the array
	var part = arguments[2] || pathArray[3]								// third arguement passed (if present) OR fourth index [3] in the array
	var elementArray = document.getElementsByName("authenticity_token");	// To get the authenticity token
	var token = elementArray[0].value;										// 	- do -	
	var url = "/destroy/" + title + "/" + part						// URL where the request has to be posted to			

	$.post(															// the AJAX POST
			url,	
			{"id": postId, "authenticity_token": token},			// The id and token being sent as data
			function(response){	delete_callback(e,response); }
	);
}
function delete_callback(e, response)
{
	// What does this do ? 
	// Removes the table row of which the deleted object is a part
	// Traverses throught the deleted element's DOM parents and deletes teh first element with a TR tag
	
	var responseObj = JSON.parse(response);
	var parentRow, moreInfoRow;
	
	if (responseObj["retVal"] == "deleted"	){
		parentRow = $(e.target).parents("tr").filter(":first");
		moreInfoRow = parentRow.next(".more_info_row").eq(0);		// more_info_row should be the next sibling
		parentRow.remove();
		if (moreInfoRow){								// If there is a more_info row separate, delete it too
			moreInfoRow.remove();
		}	
	}
	else{
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
	}
}

/*****************************************************/
function display_with_linebreaks(elements)
{	
	elements.each(function(){
		// display the element with line breaks at \n
		var temp = $(this).html().replace(/\n/g,'<br>');	// /\n/ is the regex, g (global) is to replace all occurances
		$(this).html(temp);	
	});
}

function splitName(nameObj)
{
	// splits string on square brackets. eg -
	// splits 'education[23][level]' into an array {'education', '23', 'level'}
	// or skills[skillset_type]' to array {'skills','skillset_type'}
	var str = nameObj;
	var finalarr = new Array();
	var arr1 = 	str.split('[');
	finalarr.push(arr1[0]);
	for (i=1; i<arr1.length; i++){
		arr2 = arr1[i].split(']');
		finalarr.push(arr2[0]);
	}
	return finalarr;	
}

function empty_box_handler(jObj)
{
	// jObj is a jquery object or collection of objects
	jObj.each(function(){
		if (!$(this).html())			// The element has no content
			$(this).html("--");
	});
}

function validate_inputs(validation_type, inputObj)
{
	var str = inputObj.val();
	var re;						// the regular exp
	switch (validation_type)
	{
		case "username":
			re = /^[a-zA-Z0-9_]+$/;			// /^[\w ]+$/ will make spaces also valid
			result = re.test(str);	
			break;
			
		case "password":
			if (str==""){	result=false;	}
			else		{	result=true;	}
			break;
			
		case "email":
			re = /@/;						// checks the presence of one or more @ symbols
			result = re.test(str);
			break;
			
		case "resume_title":
			re = /^[a-zA-Z0-9_]+$/;			// /^[\w ]+$/ will make spaces also valid
			result = re.test(str);	
			break;
			
		default:
			break;
	}
	
	return result;		// true if valid, false if invalid
}

function msg_baloon(msg_type, msg_text)
{
	$.jGrowl(msg_type+": "+msg_text);
}	