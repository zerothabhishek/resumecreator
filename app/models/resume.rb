class Resume < ActiveRecord::Base
  belongs_to :user
  has_many :parts
  has_one :contact
  has_one :profile
  has_many :educations
  has_many :experiences
  has_one :hobby			
  has_one :achievement  	
  has_many :skills
  
  
  def create_default_parts
	# create the default parts for the resume - 
	# contact, profile, skills, education, experience  - in that order
	
	# contact
	# create the hash
	contact_hash = HashWithIndifferentAccess.new()
	contact_hash = 	{	:title => "contact", :meta_desc => "stores contact data",
						:subpart => { "0" => {:title => "", :meta_desc => "", :keyvaluepair =>""} }		}
	contact_hash[:subpart]["0"][:keyvaluepair] =
					{	"0" => { :key => "address", 	:value => "" },
						"1" => { :key => "phone_nos",	:value => "" },
						"2" => { :key => "emails",		:value => "" }		}
	
	# now create the contact object, and add it to resume
	contact_obj = Part.new
	contact_obj.create_it(contact_hash)
	self.parts << contact_obj

	
	# profile
	# create the profile
	profile_hash = HashWithIndifferentAccess.new()
	profile_hash = 	{	:title => "profile", :meta_desc => "stores profile data - key value pairs have no key - only data this part holds is the title and the value",
						:subpart => { "0" => {:title => "", :meta_desc => "", :keyvaluepair =>""} }		}
	profile_hash[:subpart]["0"][:keyvaluepair] =
					{	"0" => { :key => "", 	:value => "" }		}
	
	# now create the profile object, and add it to resume
	profile_obj = Part.new
	profile_obj.create_it(profile_hash)
	self.parts << profile_obj
	
	# skills
	# create the hash
	skills_hash = HashWithIndifferentAccess.new()
	skills_hash = 	{	:title => "skills", :meta_desc => "stores skill data",
						:subpart => { "0" => {:title => "", :meta_desc => "", :keyvaluepair =>""} }	 	}						
	skills_hash[:subpart]["0"][:keyvaluepair] =
					{	"0" => { :key => "skill name", 		:value => "" },
						"1" => { :key => "expertise level",	:value => "" },
						"2" => { :key => "remarks",			:value => "" }	}
	
	# now create the skills object, and add it to resume
	skills_obj = Part.new
	skills_obj.create_it(skills_hash)
	self.parts << skills_obj
	
	
	# education
	# create the hash
	education_hash = HashWithIndifferentAccess.new()
	education_hash ={	:title => "education", :meta_desc => "stores education data",
						:subpart => { "0" => {:title => "", :meta_desc => "", :keyvaluepair =>""} }		}						
	education_hash[:subpart]["0"][:keyvaluepair] =
					{	"0" => { :key => "level", 		:value => "" },
						"1" => { :key => "institution",	:value => "" },
						"2" => { :key => "major",		:value => "" },
						"3" => { :key => "marks",		:value => "" },
						"4" => { :key => "more_info",	:value => "" }	}
	
	# now create the education object, and add it to resume
	education_obj = Part.new
	education_obj.create_it(education_hash)
	self.parts << education_obj
	
	
	# experience
	# create the hash
	experience_hash = HashWithIndifferentAccess.new()
	experience_hash ={	:title => "experiences", :meta_desc => "stores experiences data",
						:subpart => { "0" => {:title => "", :meta_desc => "", :keyvaluepair =>""} }		}						
	experience_hash[:subpart]["0"][:keyvaluepair] =
					{	"0" => { :key => "designation",	:value => "" },
						"1" => { :key => "company",		:value => "" },
						"2" => { :key => "duration",	:value => "" },
						"3" => { :key => "role",		:value => "" },
						"4" => { :key => "more_info",	:value => "" }	}
	
	# now create the education object, and add it to resume
	experience_obj = Part.new
	experience_obj.create_it(experience_hash)
	self.parts << experience_obj
	
  end
  
  def update_it(resume_hash)
	
	done_change = false
	
	if resume_hash[:name] || resume_hash[:meta_desc]
		self.name = resume_hash[:name]				unless !resume_hash[:name]
		self.meta_desc = resume_hash[:meta_desc]	unless !resume_hash[:meta_desc]
		done_change = true
	end

	if resume_hash[:parts]
		part_hash_list = resume_hash[:parts]
		part_hash_list.each_pair do |part_id, part_hash|
			part_obj = self.parts.find(part_id)
			result = part_obj.update_it(part_hash)		# true if the part changes
			done_change = true 		if result			# if any of the part changes, change is done
		end	
	end
	
	self.save		if done_change
	return done_change
  end
  
	def clone_it
		# creates and returns a deep copy of the resume
		return Marshal::load(Marshal.dump(self))
	end
  
end
