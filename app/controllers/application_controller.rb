# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
		
	# filter - this filter routine is executed BEFORE starting the action,
	# and looks for the existence of the session
	protected


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
