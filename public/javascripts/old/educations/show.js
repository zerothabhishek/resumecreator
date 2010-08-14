var bgColor;

$(document).ready(function(){
	
	bgColor = "white";
	$.ajaxSetup ({ cache: false });
	$(".deleteButton").hover( 
						function(){ $(this).css({"background-color":"red","cursor":"default"})}, 
						function(){ $(this).css({"background-color":bgColor,"cursor":"auto"})} 
						);
	$(".deleteButton").bind("click", function(e){ delete_it1(e); });
	$(".more_info").each( function(){display_with_linebreaks($(this)); });
});	

function delete_it1(e)
{
	var deleteButton, authToken, title;
	var postUrl, postData = new Object();
	
	var ans = confirm("Sure?"); 
	if (!ans){ 
		return;
	}	
	
	deleteButton = $(e.target);
	authToken = $("*[name='authenticity_token']").eq(0).val();
	title = window.location.pathname.split("/")[2];
	postUrl = '/destroy/'+title+'/educations';
	postData["authenticity_token"] = authToken;
	postData["id"] = deleteButton.attr("id");
	
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
	
	if (responseObj["retVal"] != "deleted"	){
		$.jGrowl(responseObj["retVal"]);				// XXX: Change this action to something better
		return;
	}	
	
	deleteButton = $(e.target);
	removeable_element = deleteButton.parents(".deleteable").eq(0);	
	removeable_element.remove();
}
