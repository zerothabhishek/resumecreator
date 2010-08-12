

$(document).ready(function(){

	$.ajaxSetup ({ cache: false });
	
	activate_availability_check();
	activate_tooltips();
	activate_validators();
	
	deactivate_signup_button();		// activated only when user enters valid input
	
});

function activate_availability_check()
{
	var availability_check_button = $("#signup_form").find(".availability_check_button").eq(0);
	
	availability_check_button.bind("click", function(e){			// click 
		post_availability_check_request(e);	
	});
	
	availability_check_button.hover(								// hover	
				function(){ $(this).css({"border-bottom":"1px solid black", "cursor":"pointer"})},
				function(){ $(this).css({"border":"0", "cursor":"auto"})}
	);		
}

function post_availability_check_request(e)
{
	var username = $("#signup_form").find("[name='user[username]']").eq(0).val();
	if (!username){	return; 	}
		
	var authToken = $("*[name='authenticity_token']").eq(0).val();	
	var postUrl = "/user/check_availability";
	var postData = new Object();

	postData["username"] = username;
	postData["authenticity_token"] = authToken;
	postData["ajax"] = "true";

	$.post(
			postUrl,
			postData,
			function (response){ 
				availability_check_callback(e,response);
			}
	)	
}		

function availability_check_callback(e, response)
{
	var responseObj = JSON.parse(response);	
	var check_result_element = $(e.target).siblings(".result").eq(0);
	check_result_element.html(responseObj["retVal"]);
	
	if (responseObj["retVal"]=="not available"){
		check_result_element.css({color: "red"});
	}else if (responseObj["retVal"]=="available"){
			check_result_element.css({color: "green"});
	}		

}

function activate_tooltips()
{

	// for all input boxes
	$("#signup_form").find(".tooltip_trigger").each(function(){
				var tooltip_html = $(this).siblings(".tooltip").eq(0).html();
				$(this).tipTip({ 
							activation: "focus",
							defaultPosition: "right", 
							delay: 100, 
							maxWidth: "15em", 
							content: tooltip_html
						});	
	});
}

function activate_validators()
{
	var valid;
	
	// validate the username
	var usernameObj = $("#signup_form").find("[name='user[username]']").eq(0);
	usernameObj.blur(function(e){
		valid = validate_inputs("username", $(this));
		if(!valid){
			$.jGrowl("invalid username");
			deactivate_signup_button();
		}else{	
			activate_signup_button();}
	});
	
	// validate the password
	var passwordObj = $("#signup_form").find("[name='user[password]']").eq(0);
	passwordObj.blur(function(e){
		valid = validate_inputs("password", $(this));
		if(!valid){
			$.jGrowl("password invalid");	}
	});	

	// validate the repeated password
	var repeatPasswordObj = $("#signup_form").find("[name='password_again']").eq(0);
	repeatPasswordObj.blur(function(e){
		var passwordObj = $("#signup_form").find("[name='user[password]']").eq(0);
		if($(this).val() != passwordObj.val()){
			$.jGrowl("passwords don't match");
		}
	});
	
	// validate the email
	var emailObj = $("#signup_form").find("[name='user[email_id]']").eq(0);
	emailObj.blur(function(e){
		valid = validate_inputs("email", $(this));
		if(!valid){
			$.jGrowl("email looks invalid");}
	});
}



function deactivate_signup_button()
{
	var signup_button = $("#signup_form").find("[name='commit']").eq(0);
	var dummy_signup_button = $("#signup_form").find(".dummy_submit").eq(0);
	
	signup_button.hide();
	dummy_signup_button.show();
}
function activate_signup_button()
{
	var signup_button = $("#signup_form").find("[name='commit']").eq(0);
	var dummy_signup_button = $("#signup_form").find(".dummy_submit").eq(0);
	
	signup_button.show();
	dummy_signup_button.hide();
}