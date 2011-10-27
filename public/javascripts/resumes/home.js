
$(document).ready(function(){
	$.ajaxSetup ({ cache: false });

	activate_older_resume();
});

function activate_older_resume(){
	var older_resume_block = $("#older_resume");
	var older_resume_activator = older_resume_block.find(".older_resume_heading > .interior");

	older_resume_activator.toggle(
		function(){		show_older_resume();	},
		function(){		hide_older_resume();	}
	);

	older_resume_activator.hover(
		function(){		$(this).addClass("older_resume_highlight");			},
		function(){		$(this).removeClass("older_resume_highlight");		}
	);
}
function show_older_resume()
{
	var older_resume_block = $("#older_resume");
	var older_resume_list = older_resume_block.find(".older_resume_list");

	older_resume_list.slideDown("slow");
}

function hide_older_resume()
{
	var older_resume_block = $("#older_resume");
	var older_resume_list = older_resume_block.find(".older_resume_list");

	older_resume_list.slideUp("slow");
}
