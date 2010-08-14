var bgColor;

$(document).ready(function(){
	
	bgColor = "white";
	$.ajaxSetup ({ cache: false });
	$(".plusButton").hover( 
						function(){ $(this).css({"background-color":"#dedede", "cursor":"default"})}, 
						function(){ $(this).css({"background-color":bgColor, "cursor":"auto"})} 
						);
	$(".plusButton").bind("click", function(e){ add_skill_row(e); });
	
	$(".heading").eq(0).width($(".skills_table").eq(0).width());	// set the width of the heading = width of table	
});	

function add_skill_row(e)
{
	var lastRow, newRow, id;
	
	lastRow = $(".table_data_row").filter(":last");
	newRow  = lastRow.clone(true);
	id 		= $(".table_data_row").length;		// set the id for new rows- one more than index of last row = no. of rows
		
	newRow.find("INPUT").each(function(){
				var nameArray, newAttr;
				nameArray = splitName($(this).attr("name"));				// e.g- split skills[<%= i %>][skill_name] on [ & ]
				newAttr = nameArray[0] + '['+id+']' + '['+nameArray[2]+']';	// reconstruct the name attribute
				$(this).attr("name", newAttr);
				$(this).val("");
	});

	lastRow.after(newRow);
}