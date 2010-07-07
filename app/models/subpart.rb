class Subpart < ActiveRecord::Base
  belongs_to :part
  has_many :keyvaluepairs
  
	def self.create(subpart_hash)
		subpart_obj = Subpart.new
		subpart_obj.title = subpart_hash[:title]
		subpart_obj.meta_desc = subpart_hash[:meta_desc]
		
		kvps_list = subpart_hash[:keyvaluepairs]			# subpart_hash contains a list of kvps
		kvps_list.each_value do |kvp_hash|					# separate out an individial kvp hash
			kvp_obj = Keyvaluepair.create(kvp_hash)			# get a new object 
			subpart_obj.keyvaluepairs << kvp_obj			# add this key value pair to the subpart obj
		end

		subpart_obj	
	end
	
	def self.create_from_part(part_id)
		# creates a new subpart by deep cloning the (latest updated) subpart of the given part,
		# and then removing all the data(values) in it

		part = Part.find(part_id)
		subpart = part.subparts.find(:first, :order => "updated_at DESC") 	# the subpart to be cloned
		new_subpart = subpart.clone_it										# clone the subpart	
		
		for kvp in new_subpart.keyvaluepairs; 								# remove all the data in the subpart
			kvp.value = "";		
		end
		
		part.subparts << new_subpart			# add the new subpart to the part
		part.save								# save the part
		
		new_subpart								# return the new subpart
	end
	
	#def self.create_it(subpart_hash)
	#	# return a new subpart object that contains the keyvaluepairs also, 
	#	# according to the passed hash - the passed hash is a single subpart hash (and not the subparts list)
	#	# eg of a subpart_hash - H_sp1 (and H_sp2) below is subpart hashes
	#	# {:subparts=> {"12"=>H_sp1, "13"=>H_sp2}
	#	# eg - H1 is {:title=>"xyz",:meta_desc=>"abc",:keyvaluespairs=>{"45"=>{:key=>"1",:value=>"abhi"},"46"=>{:key=>"2",:value=>"uma"}}}
	#	# does not save the newly created object
	#	
	#	subpart_obj = Subpart.new
	#	subpart_obj.title = subpart_hash[:title]
	#	subpart_obj.meta_desc = subpart_hash[:meta_desc]
	#	
	#	kvps_list = subpart_hash[:keyvaluepairs]			# subpart_hash contains a list of kvps
	#	kvps_list.each_value do |kvp|						# separate out an individial kvp
	#		kvp_obj = Keyvaluepair.create_it(kvp)			# get a new object 
	#		subpart_obj.keyvaluepairs << kvp_obj			# add this key value pair to the subpart obj
	#	end
	#
	#	return subpart_obj	
	#end
	
	def update_it(subpart_hash)
  
		done_change = false
		if subpart_hash[:title] || subpart_hash[:meta_desc]
			self.title = subpart_hash[:title]			if subpart_hash[:title]
			self.meta_desc = subpart_hash[:meta_desc]	if subpart_hash[:meta_desc]
			done_change = true
		end
		
		if subpart_hash[:keyvaluepairs]
			kvp_list = subpart_hash[:keyvaluepairs]
			kvp_list.each_pair do |kvp_id, kvp_hash|
				kvp_obj = self.keyvaluepairs.find(kvp_id)
				result = kvp_obj.update_it(kvp_hash)
				done_change = true		if result			# if any one of the kvps is updated, subpart is changed
			end
		end
		
		self.save		if done_change
		return done_change
	end 
	
	def clone_it
		# creates and returns a (unsaved) deep copy of the subpart
		sp = self.clone 						# shallow clone with id as nil
		self.keyvaluepairs.each do |kvp|		# create clone of the associations
			sp.keyvaluepairs << kvp.clone_it
		end
		sp
	end

	def belongs_to_user? user_id
		part = Part.find(self.part_id)
		resume = Resume.find(part.resume_id)
		user = resume.user_id
		user.id == user_id
	end
	
end
