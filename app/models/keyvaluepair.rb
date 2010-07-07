class Keyvaluepair < ActiveRecord::Base
  belongs_to :subpart

	def self.create_it(kvp_hash)
		# creates a new key-value-pair object from the passed kvp hash (not the kvp hash list)
		# does not save the object
	
		kvp_obj = Keyvaluepair.new
		kvp_obj.key = kvp_hash[:key]
		kvp_obj.value = kvp_hash[:value]
		kvp_obj
	end
  
	def update_it(kvp_hash)
  
		done_change = false
		if kvp_hash[:key] || kvp_hash[:value]
			self.key = kvp_hash[:key]			if kvp_hash[:key]
			self.value = kvp_hash[:value]		if kvp_hash[:value]
			done_change = true
		end
		
		self.save		if done_change
		return done_change
	end   
	
	def clone_it
		# creates and returns a (unsaved) deep copy of the keyvaluepair
		self.clone 				# shallow clone with id as nil
	end	
end
