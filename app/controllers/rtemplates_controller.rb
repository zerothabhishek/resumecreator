class RtemplatesController < ApplicationController

	before_filter :check_session,			# filter routine (applied before the action starts) checks for session
		:only => [:change, :preview]
		
	# GET /change/:title/templates
	def change
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@all_rtemplates = Rtemplate.all
	end

	# POST /set_rtemplates
	def set_rtemplates
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@resume.rtemplate_id = params["rtemplate_id"].to_i
		result = @resume.save
		if params["ajax"] =="true"
			if result
				render :json => { :retVal => "set"}
			else
				render :json => { :retVal => "error setting"}
			end
		end 
	end
	
	#GET /preview/:title/:rtname
	def preview
		@rtemplate = Rtemplate.find(:first, :conditions => ["name =?", params[:rtname]])
		@resume = Resume.find(:first, :conditions => ["title =?",params[:title]])
		@skills = @resume.skills.all(:order => "skillset_type")
		render :file =>
			"" + @rtemplate.location
	end
end
