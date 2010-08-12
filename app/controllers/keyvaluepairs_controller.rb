class KeyvaluepairsController < ApplicationController



  # GET /keyvaluepairs/:id
  def new
    @kvp = Keyvaluepair.new
  end
  
  # POST /keyvaluepairs 
  def create
    keyvaluepair_hash = params[:keyvaluepair]
    @kvp = current_user.keyvaluepairs.find(params[:id])
  end
  
  # GET /keyvaluepairs/:id/edit
  def edit
    @kvp = current_user.keyvaluepairs.find(params[:id])
  end
  
  # PUT /keyvaluepairs/:id
  def update
    @kvp = current_user.keyvaluepairs.find(params[:id])
  end
  
  # DELETE /keyvaluepairs/:id
  def destroy
    @kvp = current_user.keyvaluepairs.find(params[:id])
  end

  # POST /parts
  def create
    @part = Part.create!(params_hash)
	# redirect after checking if its an AJAX request
  end
  
  # GET /parts/:id/edit
  def edit
    @part = current_user.parts.find(params[:id])
  end
  
  # PUT /parts/:id
  def update
    @part = current_user.parts.find(params[:id])
	part_hash = params[:part]
    @part.update(part_hash)
  end
  
  # DELETE /parts/:id
  def destroy
    @part = current_user.parts.find(params[:id])
	@part.destroy
  end
 

	# POST /update/keyvaluepairs
	#def update
	#	kvp_hash = params[:keyvaluepair]		# eg- {:keyvaluepair=>{"23"=>{:key=>"email",:value=>"abhi@abhi.com"}}}
	#	kvp_id = kvp_hash.keys[0]._i			# "23" in above eg, convert to integer
	#	kvp = kvp_hash.value[0]					# {:key=>"email",:value=>"abhi@abhi.com"} in above eg
	#	
	#	kvp_obj = Keyvaluepair.find(kvp_obj)
	#	kvp_obj.key = kvp[:key]
	#	kvp_obj.value = kvp[:value]
	#	kvp_obj.subpart_id = ""
	#	
	#end

end
