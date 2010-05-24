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
		end

	def update_timestamp(resume)
		retVal	= resume.update_attributes({"updated_at" => DateTime.now()})
		if  !retVal 
			logger.warn "Warning: problem updating resume timestamp" 
		end	
		return		
	end


	def update_contact(resume)
	 	@contact 	= resume.contact
	 	contactPut 	= params[:contact]
	 	retVal = @contact.update_attributes(contactPut)
		if retVal 
			update_timestamp(resume)
		end	
		return retVal	
	end
	
	def update_profile(resume)
		@profile 	= resume.profile
		profilePut 	= params[:profile]
		retVal = @profile.update_attributes(profilePut)
		if retVal 
			update_timestamp(resume)
		end	
		return retVal
	end
	
	def update_skills(resume)
		@skills 	= resume.skills
		skillsPut 	= params[:skills]
		if (!skillsPut)
			return
		end
		for @skill in @skills
			retVal = @skill.update_attributes(skillsPut[@skill.id.to_s])
			if !retVal 
				break
			end			# if
		end				# for						
		if retVal 
			update_timestamp(resume)
		end	
		return retVal	
	end
	
	def update_educations(resume)
		@educations 	= resume.educations
		educationPut 	= params[:education]
		if (!educationPut)
			return
		end
		for @education in @educations
			retVal = @education.update_attributes(educationPut[@education.id.to_s])
			if !retVal
				break
			end
		end
		if retVal 
			update_timestamp(resume)
		end	
		return retVal
	end
	
	def update_experiences(resume)
		@experiences 	= resume.experiences
		experiencePut 	= params[:experience]
		if (!experiencePut)
			return
		end
		for @experience in @experiences
			retVal = @experience.update_attributes(experiencePut[@experience.id.to_s])
			if !retVal
				break
			end
		end	
		if retVal 
			update_timestamp(resume)
		end	
		return retVal
	end
	
	def update_achievement(resume)
		@achievement 	= resume.achievement
		achievementPut 	= params[:achievement]
		retVal 			= @achievement.update_attributes(achievementPut)
		if retVal 
			update_timestamp(resume)
		end	
		return retVal
	end

	def update_hobby(resume)
		@hobby 		= resume.hobby
		hobbyPut 	= params[:hobby]
		retVal 		= @hobby.update_attributes(hobbyPut)
		if retVal 
			update_timestamp(resume)
		end	
		return retVal
	end
	
	
	# returns one of the predefined parts, defined as globals in intializers/globals.rb
	# on adding a new part there, an entry should be made here
	def get_predefined_part(part_title)

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
