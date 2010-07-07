# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
	
	
	# filter - this filter routine is executed BEFORE starting the action,
	# and looks for the existence of the session
	private 					
	def check_session		
		if session[:current_user_id].nil?
			# user not logged in, redirect him to root
			flash[:notice] = "No user logged in ....!"
			redirect_to '/index'
		end		
	end	
		
	def set_urls(resume)
		# global urls
		@index_url		= "/index"
		@home_url 		= "/home"
		@new_resume_url	= "/new"
		@logout_url		= "/logout"	
		# resume specific urls
		@dashboard_url	= "/dashboard/#{resume.title}"				unless !resume
		@edit_url 		= "/edit/#{resume.title}" 					unless !resume
		@options_url 	= "/options/#{resume.title}" 				unless !resume
		@view_url		= "/view/#{resume.title}" 					unless !resume
		@pdf_url		= "/makepdf/#{resume.title}" 				unless !resume
		@publish_url 	= "#{@options_url}#publish" 				unless !@options_url
		@templates_url 	= "#{@options_url}#templates" 				unless !@options_url
		
		@output_url		= @view_url									if @view_url
	end


	def get_predefined_part(part_title)
	# returns one of the predefined parts, defined as globals in intializers/globals.rb
	# on adding a new part there, an entry should be made here

		hash = {}
		case part_title
		when "contact"
			hash = CONTACT
		when "profile"
			hash = PROFILE
		when "skills"
			hash = SKILLS
		when "education"
			hash = EDUCATION
		when "experiences"
			hash = EXPERIENCE
		when "hobbies"
			hash = HOBBIES
		when "achievements"
			hash = ACHIEVEMENTS	
		end
		hash		# return the hash
	end
end
