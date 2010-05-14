class PartsController < ApplicationController

	# GET show/:resumeTitle/:partTitle
	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:resumeTitle]])			
		@part = @resume.parts.find(:first, :conditions => ["title =?",params[:partTitle]])	
	end

	# GET new/:title/part
	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@part = Part.new
		@subpart = Subpart.new			
		@keyvaluepair = Keyvaluepair.new
		
	end
	
	# POST create/:title/part
	def create
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		
		part_hash_sent = params[:part]						# all the part data sent
		part_obj = Part.new
		part_obj.create_it(part_hash_sent)					# create the part (create_part defined in application_controller.rb)
		
		@resume.parts << part_obj							# add the newly created part to the resume
		if !@resume.save									# save the resume - saves the parts, subparts and keyvaluepairs too		
			flash[:error] = "Error creating the part"
			logger.error "Error: #{@user.username}-#{resume.title} - save failed after part creation"
		end		
	end
	
	# POST create2/part
	def create2
		begin
			@user = User.find(session[:current_user_id])
			@resume = @user.resumes.find_by_title(params[:title])
			part_title = params[:part_title]
			part_hash = get_predefined_part(part_title)			# gets the predefined hash for the part. defined in application_controller.rb
			part_obj = Part.new
			part_obj.create_it(part_hash)						# create the part with subparts and keyvaluepairs 
			@resume.parts << part_obj							# add the newly created part to the resume
			@resume.save										# save the resume - saves the parts, subparts and keyvaluepairs too		
		rescue
			flash[:error] = "Error creating the part"
			logger.error "Error: exception in part creation"
			render :json => { :retVal => "error", :error => flash[:error] }
		end
		
		render :partial => "parts/show", :locals => { :part => part_obj }
	end
	
	# GET edit/:resumeTitle/:partTitle
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@educations = @resume.educations.all		
	end	

	# POST update/:resumeTitle/:partTitle
	def update
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		eduRetVal = update_educations(@resume)
		errorText =	eduRetVal ? "Educations updated "	: "Error updating educations"   	
		if params["ajax"]
			render :json => {:retVal => "updated" }
		else	
			redirect_to session[:return_to]		
		end
	end	
	
	# POST destroy/:resumeTitle/:partTitle
	def destroy
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@education = @resume.educations.find(params["id"])	
		retStr = @education.destroy ? "deleted" : "Error deleting"
		render :json => {:retVal => retStr }
	end


	
end
