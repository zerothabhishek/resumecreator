var bgColor;

$(document).ready(function(){

	bgColor = "white";
	$.ajaxSetup ({ cache: false });

	$(".experience_table").hide();					// hide all the form tables
	$(".experience_table").eq(0).show();			// show only the first one
	$(".tab_item").hover(
					function(){ 					// XXX: use hasClass here, instead of reg-ex
						if ($(this).attr("className").search("inactive_tab") == -1)		// Done to NOT highlight the active tab.
							return;														// Reg-ex check. Returns -1 if not found
						$(this).css({"background-color":"#D3D3D3", "cursor":"default"})
					},
					function(){
						$(this).css({"background-color":"#FFFFFF", "cursor":"auto"})
					}
	);

	$(".tab_item").addClass("inactive_tab");									// De-activate all the tabs
	$(".tab_item").eq(0).removeClass("inactive_tab").addClass("active_tab");	// Activate the first tab
	$(".tab_item").bind("click",function(e){ show_tab(e) });

	$(".heading").eq(0).width($(".experience_table").eq(0).width());	// set the width of the heading = width of table

});

function show_tab(e)
{
	var target_id = $(e.target).attr("id");
	var id = target_id.split("_")[1];			// split on '_' and pick up the second part
	var table_id = "table_"+id;

	$(".experience_table").hide();		// hide all others
	$("#"+table_id).show();				// show the required one

	$(".tab_item").removeClass("active_tab").addClass("inactive_tab");	// De-activate all the tabs
	$(e.target).removeClass("inactive_tab").addClass("active_tab");		// Activate the target tab
}

