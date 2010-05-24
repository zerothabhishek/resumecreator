class Part < ActiveRecord::Base
  belongs_to :resume
  has_many :subparts
  
  def create_it(part_hash)
  		# give it a part_hash in standard format, 
		# and it creates a part object, and returns it
		
		self.title = part_hash[:title]
		self.meta_desc = part_hash[:meta_desc]
		
		subpart_list = part_hash[:subparts]				# part_hash contains a list of subparts (structured as a hash - keys are indices)
		subpart_list.each_value do |subpart|			# separate out an individual subpart from the list
			subpart_obj = Subpart.new
			subpart_obj.title = subpart[:title]
			subpart_obj.meta_desc = subpart[:meta_desc]
			kvps_list = subpart[:keyvaluepairs]			# subpart contains a list of kvps
			kvps_list.each_value do |kvp|				# separate out an individial kvp
				kvp_obj = Keyvaluepair.new
				kvp_obj.key = kvp[:key]
				kvp_obj.value = kvp[:value]
				subpart_obj.keyvaluepairs << kvp_obj	#add this key value pair to the subpart obj
			end
			self.subparts << subpart_obj			# add this subpart to the part obj
		end
		
		return self
  end
  
  def update_it(part_hash)
  
	done_change = false
	
	if part_hash[:title] || part_hash[:meta_desc]
		self.title = part_hash[:title]			unless part_hash[:title]
		self.meta_desc = part_hash[:meta_desc]	unless part_hash[:meta_desc]
		done_change = true
	end
	
	if part_hash[:subparts]
		subpart_list = part_hash[:subparts]
		subpart_list.each_pair do |subpart_id, subpart_hash|
			subpart_obj = self.subparts.find(subpart_id)
			result = subpart_obj.update_it(subpart_hash)
			done_change = true		if result				# if any of the subparts is updated, change is done
		end
	end
	
	self.save		if done_change
	return done_change
  end
  
  
	def clone_it
		# creates and returns a deep copy of the part
		return Marshal::load(Marshal.dump(self))
	end
  

end
