class KeyvaluepairsController < ApplicationController

	# POST /update/keyvaluepairs
	def update
		kvp_hash = params[:keyvaluepair]		# eg- {:keyvaluepair=>{"23"=>{:key=>"email",:value=>"abhi@abhi.com"}}}
		kvp_id = kvp_hash.keys[0]._i			# "23" in above eg, convert to integer
		kvp = kvp_hash.value[0]					# {:key=>"email",:value=>"abhi@abhi.com"} in above eg
		
		kvp_obj = Keyvaluepair.find(kvp_obj)
		kvp_obj.key = kvp[:key]
		kvp_obj.value = kvp[:value]
		kvp_obj.subpart_id = ""
		
		end
	end

end
