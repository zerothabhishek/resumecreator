var bgColor;

$(document).ready(function(){
	
	bgColor = "white";
	$.ajaxSetup ({ cache: false });

	$(".more_info").hide();
	$(".more_info_button").hover(
						function(){	$(this).css({"background-color":"#D3D3D3", "cursor":"default"})},
						function(){	$(this).css({"background-color":bgColor, "cursor":"auto"})}	);
	$(".more_info_button").toggle( 
								function(e){ 
									$(e.target).siblings(".more_info").eq(0).show("slow"); 
									$(e.target).html('-');	
								},
								function(e){ 
									$(e.target).siblings(".more_info").eq(0).hide("slow"); 
									$(e.target).html('+');
								});
		
	$(".heading").eq(0).width($(".experience_table").eq(0).width());	// set the width of the heading = width of table	
});	
