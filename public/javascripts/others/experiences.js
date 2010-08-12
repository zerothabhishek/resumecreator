$(document).ready(function(){
	
	$.ajaxSetup ({ cache: false });
	$(".deleteButton").hover( 
						function(){ $(this).css("background-color","red")}, 
						function(){ $(this).css("background-color","white")} 
						);
	$(".deleteButton").bind("click", function(e){ delete_it(e); });
	
	$(".fakeDelete").bind("click",function(e) { fake_delete(e) });	// dummy funtionality
	
});	