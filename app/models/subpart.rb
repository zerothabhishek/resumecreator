class Subpart < ActiveRecord::Base
  belongs_to :part
  has_many :keyvaluepairs
  
	def clone_it
		# creates and returns a deep copy of the sub part
		return Marshal::load(Marshal.dump(self))
	end

	def self.create_it(subpart_hash)
		# return a new subpart object that contains the keyvaluepairs also, 
		# according to the passed hash - the passed hash is a single subpart hash (and not the subparts list)
		# eg of a subpart_hash - H_sp1 (and H_sp2) below is subpart hashes
		# {:subparts=> {"12"=>H_sp1, "13"=>H_sp2}
		# eg - H1 is {:title=>"xyz",:meta_desc=>"abc",:keyvaluespairs=>{"45"=>{:key=>"1",:value=>"abhi"},"46"=>{:key=>"2",:value=>"uma"}}}
		# does not save the newly created object
		
		subpart_obj = Subpart.new
		subpart_obj.title = subpart_hash[:title]
		subpart_obj.meta_desc = subpart_hash[:meta_desc]
		
		kvps_list = subpart_hash[:keyvaluepairs]			# subpart_hash contains a list of kvps
		kvps_list.each_value do |kvp|						# separate out an individial kvp
			kvp_obj = Keyvaluepair.create_it(kvp)			# get a new object 
			subpart_obj.keyvaluepairs << kvp_obj			# add this key value pair to the subpart obj
		end

		return subpart_obj	
	end
	
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
	


end
