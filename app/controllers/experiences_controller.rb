class ExperiencesController < ApplicationController

	before_filter :check_session,			# filter routine (applied before the action starts) checks for session
		:only => [:show, :new, :create, :destroy, :edit, :update] 	# actions where filter is applied

	# GET show/:title/experiences
	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@experiences = @resume.experiences.all	
		session[:return_to] = "/show/"+@resume.title+"/experiences"
	end

	# GET new/:title/experiences
	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
	end

	# POST create/:title/experiences
	def create
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@experience = @resume.experiences.build(params[:experience])
		return_val = @experience.save
		if return_val
			update_timestamp(@resume)
		end			
		flash[:notice] =  return_val ? "experience instance created" : "Error saving experience"
		if params["ajax"]
			if return_val
				render :json => { :retVal => "created", "id" => @experience.id }
			else
				render :json => { :retVal => "error creating" }				
			end
		else
			redirect_to session[:return_to]
		end
	end

	# POST destroy/:title/experiences
	def destroy
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@experience = @resume.experiences.find(params["id"])	
		retStr = @experience.destroy ? "deleted" : "Error deleting"
		render :json => {:retVal => retStr }
	end
	
	# POST destroyall/:title/experiences
	def destroyall
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		flash[:notice] = ""
		for experience in @resume.experiences
			expId = experience.id.to_s
			expRetVal = experience.destroy
			if expRetVal
				flash[:notice] += (" deleted_experience:" + expId.to_s)
			else			
				flash[:notice] += (" error_deleting_experience:" + expId.to_s)	
			end
		end
		redirect_to session[:return_to]
	end

	# GET edit/:title/experiences
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@experiences = @resume.experiences.all	
	end

	# GET edit2/:title/experiences
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@experiences = @resume.experiences.all		
	end	
	
	# POST update/:title/experiences
	def update
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		expRetVal = update_experiences(@resume)	
		flash[:notice] = expRetVal ? "Experiences updated" : "Error updating experiences"  		
		if params["ajax"]
			render :json => {:retVal => "updated" }
		else	
			redirect_to session[:return_to]		
		end
	end
end
