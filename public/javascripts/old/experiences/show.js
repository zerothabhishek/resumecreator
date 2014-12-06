var bgColor;

$(document).ready(function(){

	bgColor = "white";
	$.ajaxSetup ({ cache: false });
	$(".deleteButton").hover(
						function(){
							$(this).css({"background-color":"red","cursor":"default"});
							$(this).parents(".experience_table").eq(0).css("border","1px solid red");
						},
						function(){
							$(this).css({"background-color":bgColor,"cursor":"auto"});
							$(this).parents(".experience_table").eq(0).css("border","0");
						});
	$(".more_info").each( function(){display_with_linebreaks($(this)); });
	$(".role").each( function(){display_with_linebreaks($(this)); });
	$(".deleteButton").bind("click", function(e){ delete_experience(e); });

});

function delete_experience(e)
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

	postUrl = '/destroy/'+title+'/experiences';
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
	var parentTable, deleteButton;
	var responseObj = JSON.parse(response);

	if (responseObj["retVal"] != "deleted"	){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;
	}

	deleteButton = $(e.target);
	parentTable = deleteButton.parents(".experience_table").eq(0);
	parentTable.remove();
}