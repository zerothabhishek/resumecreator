class SubpartsController < ApplicationController

	# GET new/subpart/:part_id
	def new
		# creates a new subpart object for a part
		# similar in structure to another subpart (first) of the same part
		# the part id is passed as a param
		# NOTE: if that part doesn't contain any subparts, its an EXCEPTION, 
		# as a part should have at least one subpart
				
		part_obj = Part.find(params[:part_id])					# the part in question
		first_subpart_obj = part_obj.subparts.find(:first)		# the first subpart, it should have one
		new_subpart_obj = Subpart.new							# create the new subpart
		new_subpart_obj.title = first_subpart_obj.title			# and set its title and meta_desc
		new_subpart_obj.meta_desc = first_subpart_obj.meta_desc
	
																# the new subpart should have the same kvps as the first one
		all_kvps = first_subpart_obj.keyvaluepairs				# get the keyvaluepairs of the first subpart
		all_kvps.each do |kvp|									# and  		
			new_kvp = Keyvaluepair.new							# create a new kvp
			new_kvp.key = kvp.key								# set the key of the new kvp
			new_subpart_obj.keyvaluepairs << new_kvp			# add the new kvp to the new subpart
		end
		part_obj.subparts << new_subpart_obj					# add the new subpart to the part
		
		@subpart = new_subpart_obj								# instance variables
		@part = part_obj										# to be used in the view
		
		if params[:ajax]="true"
			render :file=>"subparts/new.html.erb"
		else
			render :file=>"subparts/new.html.erb", :layout=>"layouts/resumes.html.erb"
		end
		
	end
	
	# POST /create/subpart
	def create
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(session[:current_resume_id])

		resume_hash = params[:resume]				# sender posts the whole hash
		part_list = resume_hash[:parts]				# the hash contains just one part 
		part_id = part_list.keys[0].to_i			# so keys[0] keys the id of the part (part_list is indexed by ids), and convert it as its a string
		part_hash = part_list.values[0]				# and value[0] gets the part_hash
		subpart_list = part_hash[:subparts]			# the subpart list contains just one subpart,
		subpart_hash = subpart_list.values[0]		# so the values[0] gets the subpart_hash
	
		new_subpart_obj = Subpart.create_it(subpart_hash)		# create the new subparts
		part_obj = @resume.parts.find(part_id)					# get the part object
		part_obj.subparts << new_subpart_obj					# add the newly created subpart to the parts
		
		@resume.save								# saves everything ( rresume, parts, subparts, kvps)
		
		id_arr = Array.new()
		id_arr << part_obj.id
		id_arr << new_subpart_obj.id
		new_subpart_obj.keyvaluepairs.each do |kvp|
			id_arr << kvp.id
		end 
		
		#sp_obj = {}
		#sp_obj[:id] = new_subpart_obj.id
		#sp_obj[:kvp_list] = Array.new()
		#new_subpart_obj.keyvaluepairs.each do |kvp|
		#	kvp_obj = {}
		#	kvp_obj[:id] = "resume_parts_#{part_obj.id}_subparts_#{new_subpart_obj.id}_keyvaluepairs_#{kvp.id}_key"
		#	kvp_obj[:name] = "resume[parts][#{part_obj.id}]subparts[#{new_subpart_obj.id}][keyvaluepairs][#{kvp.id}][key]"
		#	sp_obj[:kvp_list] << kvp_obj
		#end
		
		if params[:ajax]
			render :json=> { :retVal=>"created", :id_list => id_arr }
		end
	end

	# POST /destroy/subpart
	def destroy
		subpart_id = params[:id]

		# check if the subpart belongs to current user
		subpart = Subpart.find(subpart_id)
		part = 	Part.find(subpart.part_id)		if subpart
		resume = Resume.find(part.resume_id)	if part
		user = User.find(resume.user_id)		if resume
		
		if user.blank? or user.id!=session[:current_user_id]
			# mismatch - don't delete
			logger.error "Error: #{user.username}-#{resume.title} access error while subpart delete"
			render :json => {	:retVal=>"not deleted", :error=>"access error"	}
		end
		
		unless subpart.destroy
			# error deleting
			logger.error "Error: #{user.username}-#{resume.title} destroy error while subpart delete"
			render :json => {	:retVal=>"not deleted", :error=>"destroy error"	}
		end
		
		if part.subparts.size==0		
			# after deleting subpart, if no more subparts are left, delete the part too
			unless part.destroy
				logger.error "Error : #{user.username}-#{resume.title} destroy error while part delete"
			end 
		end
		
		render :json => { :retVal => "deleted" }
		logger.info "Info: #{user.username}-#{resume.title} subpart deleted"

	end
	
end
