var bgColor;

$(document).ready(function(){
	
	bgColor = "white";
	$.ajaxSetup ({ cache: false });
	$(".deleteButton").hover( 
						function(){ $(this).css("background-color", "red")}, 
						function(){ $(this).css("background-color", bgColor)} 
						);
	$(".deleteButton").bind("click", function(e){ delete_skills(e); });

	$(".heading").eq(0).width($(".skills_table").eq(0).width());	// set the width of the heading = width of table	
});	

function delete_skills(e)
{
	var deleteButton;
	var id;
	var ans; 
	var postUrl, authToken;
	var postData = new Object();
	var title, pathArray;
		
	ans = confirm("Sure?"); 
	if (!ans)		return;

	deleteButton = $(e.target);
	authToken = $("*[name='authenticity_token']").eq(0).val();
	id = deleteButton.attr("id").split('_')[1];					// deleteButton's Id is 'delete_<id>'
	pathArray = window.location.pathname.split("/");
	title = pathArray[2];

	postUrl = '/destroy/'+title+'/skills';
	postData["ajax"] = "true";
	postData["authenticity_token"] = authToken;
	postData["id"] = id;
	
	$.post(
		postUrl,
		postData,
		function(response){
			delete_callback(e,response);
		}
	);
}

function delete_callback(e,response)
{
	var parentRow, nextRow, deleteButton;
	var responseObj = JSON.parse(response);

	if (responseObj["retVal"] != "deleted"	){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;
	}
	
	deleteButton = $(e.target);
	parentRow = deleteButton.parents("TR").eq(0);
	nextRow = parentRow.next("TR");
	if (nextRow.length) {							// nextRow isn't null if nothing is returned
		var checkParent = parentRow.attr("class").search("new_skillset");	// row contains skillset_type: returns -1 if not
		var checkNext   = nextRow.attr("class").search("new_skillset");		
		if(checkParent!=-1 && checkNext==-1){								// parent contains skillset type
			var temp1 = nextRow.find(".skillset_type").eq(0);				// nextRow doesn't
			var temp2 = parentRow.find(".skillset_type").eq(0);
			temp1.replaceWith(temp2);
			nextRow.addClass("new_skillset");
		}
	}
	parentRow.remove();
}