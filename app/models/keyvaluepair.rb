class Keyvaluepair < ActiveRecord::Base
  belongs_to :subpart

	def self.create_it(kvp_hash)
		# creates a new key-value-pair object from the passed kvp hash (not the kvp hash list)
		# does not save the object
		# eg - in {:keyvaluepairs => {"45"=>KVP1, "51"=>KVP2}} KVP1 (and KVP2) is kvp_hash
		# where KVP1 could be {:key=>"1",:value=>"abhi"}
		
		kvp_obj = Keyvaluepair.new
		kvp_obj.key = kvp_hash[:key]
		kvp_obj.value = kvp_hash[:value]
		return kvp_obj
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
		# creates and returns a deep copy of the part
		return Marshal::load(Marshal.dump(self))
	end	
end
