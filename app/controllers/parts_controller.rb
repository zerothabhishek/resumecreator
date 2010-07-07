class PartsController < ApplicationController

	# POST create2/part
	def create2
		begin
			@user = User.find(session[:current_user_id])
			@resume = @user.resumes.find(session[:current_resume_id])
			
			part_obj = Part.create_by_title(params[:new_part_title])
			@resume.parts << part_obj									# add the newly created part to the resume
			@resume.save												# save the resume - saves the parts, subparts and keyvaluepairs too		
			
			render :partial => "parts/show", :locals => { :part => part_obj }
		end
	end
	
end
