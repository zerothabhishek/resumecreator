class ResumesController < ApplicationController
	
	before_filter :check_session,			# filter routine (applied before the action starts) checks for session
		:only => [:home, :dashboard, :options, :new, :create, :edit, :update, :destroy, :makepdf] 	# actions where filter is applied

	# GET /index	
	def index
		set_urls(@latest_resume)
		# render index.html.erb
	end
	
	# GET /home
	def home
		@user = User.find(session[:current_user_id])
		@all_resumes = @user.resumes.all(:order => "updated_at DESC")	
		@latest_resume = @all_resumes[0]
		if @latest_resume
			@rtemplate = Rtemplate.find(:first, :conditions => ["id =?",@latest_resume.rtemplate_id]) 
		end
		set_urls(@latest_resume)
	end
	
	# GET /dashboard/:title
	def dashboard
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@rtemplate = Rtemplate.find(:first, :conditions => ["id =?",@resume.rtemplate_id])	
		set_urls(@resume)
	end

	# GET /options/:title
	def options
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@rtemplate = Rtemplate.find(:first, :conditions => ["id =?",@resume.rtemplate_id])
		@all_rtemplates = Rtemplate.all
		set_urls(@resume)
		session[:return_to] = "/options/"+@resume.title
	end
	
	# GET /new
	def new
		@user = User.find(session[:current_user_id])
		set_urls(@resume)
	end
	
	# POST /create2
	def create2
	
		# get the user and check if the resume already exists
		@user = User.find(session[:current_user_id])
		if @user.has_resume(params[:resume][:title])
			logger.error "Error: #{@user.username}- resume creation- resume of same title already exists"
			flash[:error] = "A resume of same title already exists"
			redirect_to '/new'
			return
		end


		if params[:copy_name] != ""
			copy_resume = @user.resumes.find_by_title(params[:copy_name])
			if copy_resume
				@resume = copy_resume.clone_it
				
				@resume.name = params[:resume][:name]
				@resume.title = params[:resume][:title]
				@resume.meta_desc = params[:resume][:meta_desc]
				
				@resume.save
			end
		else		
			# build and save the resume
			@resume = @user.resumes.build(params[:resume])
			if !@resume.save
				logger.error "Error: #{@user.username}- resume creation- save"
				flash[:error] = "Error occurred in resume creation"
				redirect_to '/new'
				return
			end
			# create default parts for the resume 
			if !@resume.create_default_parts
				logger.error "Error: #{@user.username}-#{@resume.title} error in default parts creation"
			end
			# and save it
			if !@resume.save
				logger.error "Error: #{@user.username}-#{@resume.title} error in save after default parts creation"
			end
		end
		
		redirect_to "/edit2/#{@resume.title}"
	end
	
	# GET /edit2/:title
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		session[:current_resume_id] = @resume.id
		
		@parts_titles_list = PART_TITLES_ALL
	end
	
	# POST /update
	def update2
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(session[:current_resume_id])
		
		resume_hash = params[:resume]
		result = @resume.update_it(resume_hash)
		if params[:ajax] == "true"
			if result
				logger.info "Info: #{@user.username}-#{@resume.title} updated"
				render :json => { :retVal => "updated" }
			else
				logger.error "Error: #{@user.username}-#{@resume.title} NOT updated"
				render :json => { :retVal => "Not updated" }
			end
		end
	end
	
	# POST /create
	def create
		@user = User.find(session[:current_user_id])
		isAlreadyPresent = @user.has_resume(params[:resume][:title])
		if isAlreadyPresent == nil
			@resume = @user.resumes.build(params[:resume])
			result = @resume.save
		else
			result = nil
		end	
		
		if params["ajax"] == "true"
			if result
				logger.info "Info: New resume created - #{@user.username}-#{@resume.title}"
				render :json => { :retVal => "created", :title => @resume.title }
			else
				logger.error "Error: resume create - #{@user.username}"
				render :json => { :retVal => "resume creation failed"	}
			end
		else
			if result 
				logger.info "Info: New resume created - #{@user.username}-#{@resume.title}"
				redirect_to "/edit/#{@resume.title}"
			else	
				error_msg = "Error: resume create - #{@user.username}"
				if isAlreadyPresent
					error_msg = " Error: A resume by that title already exists"
				end
				logger.error error_msg
				flash[:error_new] = error_msg
				redirect_to '/new'	
			end		
		end	
	end


	# GET /edit/:title
	def edit
		@user = User.find(session[:current_user_id])
		if params[:title]
			@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		else	#select the latest one as no title is provided
			#@resume = @user.resumes.find(:first, :order => "updated_at DESC")
		end
		set_urls(@resume)
	end
	
	# PUT /update/:title
	def update
		
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	

		resumePut = params[:resume]

		resRetVal = @resume.update_attributes(resumePut)	# Update the name (resumePut contains the name only)
		if (params["ajax"]=="true" && params["flag"]=="name_only")
			if resRetVal
				render :json => { :retVal => "updated" }
			else
				render :json => { :retVal => "error creating" }				
			end
			return											# without this, there can be error
		end
		
		conRetVal = update_contact(@resume)					# Update the contact
		proRetVal = update_profile(@resume)					# Update the profile
		skiRetVal = update_skills(@resume)					# Update the skills
		eduRetVal = update_educations(@resume)				# Update the educations
		expRetVal = update_experiences(@resume)				# Update the experiences
		achRetVal = update_achievement(@resume)				# Update the achievement
		hobRetVal = update_hobby(@resume)					# Update the hobby
		
		errorText	=	""
		errorText 	+= 	resRetVal ? "Name updated; " 		: "Error updating name"   		
		errorText	+=	conRetVal ? "Contact updated; " 	: "Error updating contact" 		
		errorText	+=	proRetVal ? "Profile updated; " 	: "Error updating profile" 		
		errorText	+=	skiRetVal ? "Skills updated; " 		: "Error updating skills"   	
		errorText	+=	eduRetVal ? "Educations updated; "	: "Error updating educations"   
		errorText	+=	expRetVal ? "Experiences updated; " : "Error updating experiences"  
		errorText	+=	achRetVal ? "Achievements updated; ": "Error updating achievements" 
		errorText	+=	hobRetVal ? "Hobby updated; " 		: "Error updating hobby"   		
					
		flash[:notice] = errorText
		
	end

	# POST /toggle_public_status
	def toggle_public_status
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(params[:resume_id])
		
		if params["request"] == "toggle"
			@resume.public_status = (@resume.public_status == "private") ? "public" : "private"
			result = @resume.save
			if result
				render :json => { :retVal => "true", "public_status" => @resume.public_status }
			else
				render :json => { :retVal => "error", "errorText" => result }
			end
		end
	end
	
	# DELETE /destroy/:title
	def destroy
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		result 	= @resume.destroy	
		flash[:notice] = result ? "Resume destroyed" : "Error destroying resume"  
		if params["ajax"] == "true"
			if result
				render :json => { :retVal => "deleted" }
			else
				render :json => { :retVal => "error" }
			end
		else
			session[:return_to] = ""
			redirect_to root_url
		end
	end
	
	# GET /view/:title			# internal request - user is logged on and wants his own resume
	# GET /:username/:title		# external requests- for public resume - someone wants to see user's resume
	# GET /:username			# external request - for default public resume - not handled right now
	def view
		if session[:current_user_id]	# internal request
			@user 	= User.find(session[:current_user_id])
			@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
			@rtemplate = Rtemplate.find(@resume.rtemplate_id)
			render :file =>
					@rtemplate.location			
		else
			# external request - no session
			@user = User.find(:first, :conditions => ["username =?",params[:username]])
			if params[:title]	# title present in url
				@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
				if resume.public_status == "private"
					# show exception and exit
					return		
				end
			else	# no title in the url
				# show exception and exit
				return
			end
			@rtemplate = Rtemplate.find(@resume.rtemplate_id)
			render :file =>
					@rtemplate.location						
		end
	end
	
	# GET makepdf/:title   calls the wkhtmltopdf utility to create the pdf
	def makepdf
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		fileName = "#{@user.username}_#{@resume.title}"
		pdf_filePath = "#{RAILS_ROOT}/user_data/pdf/#{fileName}.pdf"
		
		# check if a pdf is already generated for this, and is not outdated
		if @resume.pdf_timestamp													# a pdf exists	
			if @resume.pdf_timestamp >= @resume.updated_at							# the pdf was created after last resume update
				send_file pdf_filePath, :type => 'pdf', :disposition => 'inline'	# send it
				logger.info "Info: Skipped resume creation - sent existing pdf"
				return
			end 
		end
		
		# render the template to a string 
		@rtemplate = Rtemplate.find(@resume.rtemplate_id)
		content = render_to_string :file =>	@rtemplate.location

		# and save it to a file
		html_filePath = "#{RAILS_ROOT}/user_data/html/#{fileName}.html"
		File.open(html_filePath, "w+") do |f| 
			f.write(content) 
		end

		# now use this file for pdf creation
		cmd = "wkhtmltopdf #{html_filePath} #{pdf_filePath}"
		logger.debug cmd
		@result = system cmd
		
		# send the created file to the browser, as inline - displayed not downloaded
		send_file pdf_filePath, :type => 'pdf', :disposition => 'inline'
		
		#update the pdf timestamp
		@resume.pdf_timestamp = DateTime.now()
		result = @resume.save
		if !result
			logger.warn "Warning: problem saving pdf timestamps"
		end
	end

	
	# GET dummy001/:title
	def dummy001
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		
		##@result = @resume.create_default_parts
		
		x = GLOBAL_VAR
		y = VAR2
		z = EDUCATION
		render :text => z[:title]
	end
	
end
