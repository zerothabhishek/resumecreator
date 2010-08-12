class Skill < ActiveRecord::Base
  belongs_to :resume
  validates_presence_of :skill_name
  
	#def self.is_empty(skillRow)
		#if skillRow.skill_name=="" 	#	and skillRow.skill_remarks=="" and skillRow.skillset_type=="")
			#return true
		#else
			#return false
	#end
end
