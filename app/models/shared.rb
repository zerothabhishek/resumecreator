# code to be shared across models
module Shared
	
	def Shared.get_predefined_part(part_title)
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
