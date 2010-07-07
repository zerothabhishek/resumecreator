class SubpartsController < ApplicationController

	# POST /create/subpart
	#def create
	#	@user 	= User.find(session[:current_user_id])
	#	@resume = @user.resumes.find(session[:current_resume_id])
	#
	#	resume_hash = params[:resume]				# sender posts the whole hash
	#	part_list = resume_hash[:parts]				# the hash contains just one part 
	#	part_id = part_list.keys[0].to_i			# so keys[0] keys the id of the part (part_list is indexed by ids), and convert it as its a string
	#	part_hash = part_list.values[0]				# and value[0] gets the part_hash
	#	subpart_list = part_hash[:subparts]			# the subpart list contains just one subpart,
	#	subpart_hash = subpart_list.values[0]		# so the values[0] gets the subpart_hash
	#
	#	new_subpart_obj = Subpart.create_it(subpart_hash)		# create the new subparts
	#	part_obj = @resume.parts.find(part_id)					# get the part object
	#	part_obj.subparts << new_subpart_obj					# add the newly created subpart to the parts
	#	
	#	@resume.save								# saves everything ( rresume, parts, subparts, kvps)
	#	
	#	id_arr = Array.new()
	#	id_arr << part_obj.id
	#	id_arr << new_subpart_obj.id
	#	new_subpart_obj.keyvaluepairs.each do |kvp|
	#		id_arr << kvp.id
	#	end 
	#	
	#	#sp_obj = {}
	#	#sp_obj[:id] = new_subpart_obj.id
	#	#sp_obj[:kvp_list] = Array.new()
	#	#new_subpart_obj.keyvaluepairs.each do |kvp|
	#	#	kvp_obj = {}
	#	#	kvp_obj[:id] = "resume_parts_#{part_obj.id}_subparts_#{new_subpart_obj.id}_keyvaluepairs_#{kvp.id}_key"
	#	#	kvp_obj[:name] = "resume[parts][#{part_obj.id}]subparts[#{new_subpart_obj.id}][keyvaluepairs][#{kvp.id}][key]"
	#	#	sp_obj[:kvp_list] << kvp_obj
	#	#end
	#	
	#	if params[:ajax]
	#		render :json=> { :retVal=>"created", :id_list => id_arr }
	#	end
	#end

	# GET /create/subpart
	def create2
		# Creates and sends a subpart within part, by cloning one of the existing subparts
		new_subpart = Subpart.create_from_part(params[:partId])	
		render :partial => "subparts/show.html.erb", :locals => { :subpart => new_subpart }
	end
	
	# POST /destroy/subpart
	def destroy
		subpart = Subpart.find(params[:id])
		
		unless subpart.belongs_to_user? session[:current_user_id]
			logger.error "Error: #{user.username}-#{resume.title} access error while subpart delete"
			render :json => {	:retVal=>"not deleted", :error=>"access error"	}
		end

		part = Part.find(subpart.part_id)
		subpart.destroy	
		part.destroy		if part.subparts.size==0
		
		render :json => { :retVal => "deleted" }
		logger.info "Info: #{user.username}-#{resume.title} subpart deleted"
	end
	
end
