
var bodyBgColor;

$(document).ready(function(){

	$.ajaxSetup ({ cache: false });

	// add intial data to the DOM
	init_data();

	// Hide all the edit elements
	$(".edit").hide();

	// All the display elements should show linebreaks(<br>) on \n
	$(".display").each(	function() { display_with_linebreaks($(this)); });
	// Hover on display elements should change the element background color
	bodyBgColor = $("BODY").css("background-color");
	$(".display").hover(
					function(){ $(this).css({"background-color":"#ABABFF", "cursor":"default"})},
					function(){ $(this).css({"background-color":bodyBgColor, "cursor":"auto"})}
	);
	// click on the display element should activate the editing
	$(".display").bind("click", function(e){ activate_edit(e);});

	// Hide all the input boxes of add-more and add-part blocks
	$(".addTable").hide();
	$(".addPart").hide();
	// Click on addMore buttons should start add functionality
	$(".plusButton").bind("click", function(e){
			var partName= $(e.target).parents(".part").eq(0).attr("id");
			if (partName=="skills" || partName=="educations" || partName=="experiences"){
				add_more(e);
			}
			else if (partName=="contacts" || partName=="profiles" || partName=="achievements" || partName=="hobbies" ){
				add_part(e);
			}
	});

	// Delete button
	$(".delete_button").hover(
					function(){
						$(this).css({"background-color":"#FF0000", "cursor":"default"})},
					function(){ $(this).css({"background-color":bodyBgColor, "cursor":"auto"})}
	);
	$(".delete_button").bind("click", function(e){ delete_it1(e); });


	empty_box_handler($(".parts_container"));

	$(".msg_baloon").hide();
	$(".parts_container").show();
});

function delete_it2(e)
{
	var partName = $(e.target).parents(".part").eq(0).attr("id");
	delete_it(e,'',partName);		// function is defined in resume_common.js, expects (event,[title],[partName])
}

function activate_edit(e)
{
	var height = $(e.target).height();
	var width = $(e.target).width();
	var font_size = $(e.target).css("font-size");					// e.g - 16px
	var font_width = font_size.slice(0,(font_size.indexOf('px')));	// e.g - 16
	var min_width;

	// hide the display element
	$(e.target).hide();

	// show the corresponding edit element, ans set its size
	var editElement = $(e.target).siblings(".edit").eq(0);
	editElement.show();

	if(editElement.get(0).tagName=='TEXTAREA'){
		min_width = 20*font_width;
		min_height = 2*font_width;
	}else{
		min_width = 15*font_width;
	}
	if (width < min_width)	{ width = min_width; }
	editElement.css({"height":height,"width":width});


	// show and add the button_stripe
	var button_stripe = $(".button_stripe").filter(".hidden").clone();
	button_stripe.removeClass("hidden");
	button_stripe.css("display","inline");
	editElement.after(button_stripe);

	// add event handlers (for update and cancel and hover) to the button stripe
	button_stripe.find(".update").bind("click",function(e){ update_it(e) });
	button_stripe.find(".clear").bind("click",function(e){ deactivate_edit(e) });
	button_stripe.find("span").hover(
				function(){ $(this).css({"border":"1px solid black", "cursor":"default"})},
				function(){ $(this).css({"border":"0", "cursor":"auto"})}
	);
}

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

function deactivate_edit(e)
{
	var button_stripe = $(e.target).parents(".button_stripe").eq(0);	// the target element is the button span
	button_stripe.hide();
	button_stripe.siblings(".edit").hide();
	button_stripe.siblings(".display").show();
	button_stripe.remove();					// remove the button from the dom
}

function update_it(e)
{
	var button_stripe = $(e.target).parents(".button_stripe").eq(0);	// the target element is the button span
	var editElement = button_stripe.siblings(".edit").eq(0);
	var displayElement = button_stripe.siblings(".display").eq(0);
	var editElementName = editElement.attr("name");
	var editElementValue = editElement.val();
	var partBlock = editElement.parents(".part").eq(0);
	var postUrl = partBlock.data("updateUrl");
	var authToken = $("*[name='authenticity_token']").eq(0).val();

	var postData = new Object();		// creating the hash for the post-data
	postData[editElementName] = editElementValue;
	postData["authenticity_token"] = authToken;
	postData["ajax"] = "true";
	if (partBlock.attr("id")=="username"){
		postData["flag"] = "name_only";			// flag tells the server to update the name only
	}

	$.post(
			postUrl,
			postData,
			function (response){
						displayElement.html(editElementValue);
						display_with_linebreaks(displayElement);
						deactivate_edit(e);
			}
	)
}

function add_more(e)
{
	var plusButton = $(e.target);
	var inputBoxesDiv = plusButton.siblings(".addTable");
	inputBoxesDiv.show();

	// show and add the button_stripe
	var button_stripe = $(".button_stripe").filter(".hidden").clone();
	button_stripe.removeClass("hidden");
	button_stripe.css("display","inline");
	inputBoxesDiv.after(button_stripe);

	// add event handlers (for update and cancel and hover) to the button stripe
	button_stripe.find(".update").bind("click",function(e){ add_it(e) });
	button_stripe.find(".clear").bind("click",function(e){ deactivate_add(e) });
	button_stripe.find("span").hover(
				function(){ $(this).css({"border":"1px solid black", "cursor":"default"})},
				function(){ $(this).css({"border":"0", "cursor":"auto"})}
	);

	// Hide the plus button for now
	plusButton.hide();
}

function deactivate_add(e)
{
	var clearButton = $(e.target);
	var button_stripe = clearButton.parents(".button_stripe").eq(0);
	var inputBoxesDiv = button_stripe.siblings(".addTable").eq(0);
	var plusButton = button_stripe.siblings(".plusButton").eq(0);

	inputBoxesDiv.hide();
	button_stripe.remove();
	plusButton.show();
}

function add_it(e)
{
	var updateButton = $(e.target);
	var addBlock = updateButton.parents(".addMore").eq(0);
	var postUrl = updateButton.parents(".part").eq(0).data("addUrl");
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var postData = new Object();			//  hash for the post-data

	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	addBlock.find(".add").each(function(){
		postData[$(this).attr('name')] = $(this).val();
	});

	$.post(
		postUrl,
		postData,
		function(response){
			add_it_callback(e,response);
			deactivate_add(e);
		}
	);
}

function add_it_callback(e, response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "created"){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;
	}

	// Make a DOM clone of the addMoreBlock>table
	// add and remove the necessary classes from the clone
	// Add it after the last table of the part

	var id = responseObj["id"], partName;
	var updateButton = $(e.target);
	var addMoreBlock = updateButton.parents(".addMore").eq(0);
	var addTable = addMoreBlock.find("TABLE").eq(0);
	var cloneTable = addTable.clone(true);				// clone has a bug in jquery1.3.2 (#3016) - it can't copy contents of <textarea>
														// So the operations are performed on the (original) add table,
														// which is inserted as the new DOM,
														// and the clone takes the place for the addTable

	addTable.find(".display").each(function(){
		$(this).removeClass("hidden");					// un-hide the display elements
		var innerHTML = $(this).siblings(".add").eq(0).val() || $(this).siblings(".add").eq(0).html();
		$(this).html(innerHTML);
	});

	addTable.find(".add").each(function(){				// each ".add" element becomes ".edit"

		$(this).removeClass("add");
		$(this).addClass("edit");
		$(this).addClass("hidden");						// Note: original ".edit" elements are hidden at the start of this script, not by "hidden" class

		var nameParts = splitName($(this).attr("name"));		// eg- split skills[skill_name] into
		partName  = nameParts[0];								//			skills
		var fieldName = nameParts[1];							//			skill_name
		var nameStr = partName+'['+id+']['+fieldName+']';		//  	skills[<id>][<skill_name>]

		$(this).attr('name',nameStr);
	});

	addTable.find(".delete_button").removeClass("hidden");	// un-hide the delete button
	addMoreBlock.before(addTable);							// Note: uses the fact that addMoreBlock appears just after the
														// experience tables. Warning: can break if markup changes in the region
	addTable.addClass(partName+"_table");				// eg- experience_table
	addTable.addClass("deleteable");
	addTable.removeClass("addTable");
	addTable.attr('id', (partName+"_"+id) );
	addMoreBlock.append(cloneTable);

}

function add_part(e)
{
	var plusButton = $(e.target);
	var partBlock = plusButton.parents(".part").eq(0);
	var addPart = partBlock.find(".addPart").eq(0);

	addPart.show();

	// add the button_stripe
	var button_stripe = $(".button_stripe").filter(".hidden").clone();		// hidden one coz it doesn't have event handlers
	button_stripe.removeClass("hidden");
	button_stripe.css("display","inline");
	addPart.after(button_stripe);

	// add event handlers (for update and cancel and hover) to the button stripe
	button_stripe.find(".update").bind("click",function(e){ add_it1(e) });
	button_stripe.find(".clear").bind("click",function(e){ deactivate_add1(e); 	plusButton.show(); });
	button_stripe.find("span").hover(
				function(){ $(this).css({"border":"1px solid black", "cursor":"default"})},
				function(){ $(this).css({"border":"0", "cursor":"auto"})}
	);

	// hide the plus button
	plusButton.hide();
}

function add_it1(e)
{
	var updateButton = $(e.target);
	var partBlock = updateButton.parents(".part").eq(0);
	var addBlock = partBlock.find(".addPart").eq(0);
	var postUrl = partBlock.data("addUrl");
	var authToken = $("*[name='authenticity_token']").eq(0).val();
	var postData = new Object();			//  hash for the post-data

	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	addBlock.find(".add").each(function(){
		postData[$(this).attr('name')] = $(this).val();
	});

	$.post(
		postUrl,
		postData,
		function(response){
			add_it_callback1(e,response);
		}
	);
}

function deactivate_add1(e)
{
	var clearButton = $(e.target);
	var partBlock = clearButton.parents(".part").eq(0);
	var addBlock = partBlock.find(".addPart").eq(0);
	var plusButton = partBlock.find(".plusButton").eq(0);
	var button_stripe = clearButton.parents(".button_stripe").eq(0);

	addBlock.hide();
	button_stripe.remove();
	// can't show the plus button here
}

function add_it_callback1(e, response)
{
	var responseObj = JSON.parse(response);
	if (responseObj["retVal"] != "created"){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;
	}

	var updateButton = $(e.target);
	var partBlock = updateButton.parents(".part").eq(0);
	var addBlock = partBlock.find(".addPart").eq(0);

	// Change the addPart by -
	// - move the data from the .add input boxes to the .display elements
	// - add and remove the necessary classes
	addBlock.find(".add").each(function(){
		var addElement = $(this);
		var displayElement = addElement.siblings(".display").eq(0);
		var innerHTML = addElement.val() || addElement.html();

		displayElement.html(innerHTML);

		addElement.removeClass("add");
		addElement.addClass("edit");
		displayElement.removeClass("hidden");
		addElement.addClass("hidden");

		display_with_linebreaks(displayElement);
	});

	// show the block and remove the addpart class
	addBlock.show();
	addBlock.removeClass(".addPart");

	// remove the button stripe
	var button_stripe = updateButton.parents(".button_stripe").eq(0);
	button_stripe.remove();
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

function delete_it1(e)
{
	var deleteButton, authToken;
	var postUrl, postData = new Object();

	deleteButton = $(e.target);
	authToken = $("*[name='authenticity_token']").eq(0).val();
	postUrl = deleteButton.parents(".part").eq(0).data("deleteUrl");
	postData["authenticity_token"] = authToken;
	postData["id"] = deleteButton.parents(".deleteable").eq(0).attr("id").split('_')[1];	// "deletable" element's id is, eg- experience_<id>

	$.post(
			postUrl,
			postData,
			function(response){	delete_it1_callback(e,response); }
	);
}

function delete_it1_callback(e, response)
{
	var deleteButton, removeable_element;
	var responseObj = JSON.parse(response);
	var partName;

	if (responseObj["retVal"] != "deleted"	){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;
	}

	deleteButton = $(e.target);
	removeable_element = deleteButton.parents(".deleteable").eq(0);

	partName = deleteButton.parents(".part").attr("id");
	if (partName == "skills"){							// additional stuff for skills part
		var next_row = removeable_element.next();
		if (next_row.length!=0){						// do stuff only if there IS a next row
			if (next_row.attr("class").search("repeat_skillset") != -1){
				// the next row has the classname 'repeat_skillset', un-hide the skillset type from it
				next_row.find(".skillset_type").eq(0).find(".display").removeClass("hidden");
			}
		}
	}

	removeable_element.remove();
}


function empty_box_handler(el)
{
	var element = el;
	var displayElements = element.find(".display");

	displayElements.each(function(){
		if (!$(this).html())			// The display element has no content
			$(this).html("--");
	});
}