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
  
  require "Shared"		# the file shared.rb is needed for Shared module
  include Shared		
  
	def self.create(params)
		# create a new resume from params, or a copy. Don't save it	
		if params[:copy_name] == ""
			# create a new resume, and create the default parts
			resume = Resume.new(params[:resume])
			resume.create_default_parts
		else
			# create a clone of copy_name resume
			copy_resume = Resume.find_by_title(params[:copy_name])
			resume = copy_resume.clone_it
			resume.name = params[:resume][:name]
			resume.title = params[:resume][:title]
			resume.meta_desc = params[:resume][:meta_desc]
		end
		resume
	end
	
	def create_default_parts
		# create the default parts for the resume - 
		# contact, profile, skills, education, experience  - in that order
		
		default_parts = ["contact", "profile", "skills", "education", "experiences"]
		for default_part in default_parts
			default_part_hash = Shared.get_predefined_part(default_part)
			default_part_obj = Part.create(default_part_hash) 
			self.parts << default_part_obj
		end
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
		# creates and returns a (unsaved) deep copy of the resume	
		r = self.clone					# a shallow clone with id as nil
		self.parts.each do |p|			# create a copy of the associations
			r.parts << p.clone_it
		end
		r
	end
  
end
