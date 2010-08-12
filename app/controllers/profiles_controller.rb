class ProfilesController < ApplicationController

	before_filter :check_session,	# filter routine (applied before the action starts) checks for session
		:only => [:show, :new, :create, :edit] 	# actions where filter is applied


	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@profile = @resume.profile	
		session[:return_to] = '/show/'+@resume.title+'/profiles'
	end
	
	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])		
	end
	
	def create
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@profile = @resume.build_profile(params[:profile])
		result = @profile.save
		if result
			update_timestamp(@resume)
		end	
		if params["ajax"]=="true"
			if result
				render :json => { :retVal => "created", "id" => @profile.id }
			else
				render :json => { :retVal => "error creating" }
			end
		else
			flash[:notice] = result ? "Profile created" : "Error creating profile"
			redirect_to session[:return_to]
		end
	end
	
	# GET /edit/:title/profiles
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@profile = @resume.profile	
	end

	# GET /edit2/:title/profiles
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@profile = @resume.profile	
	end
	
	def update
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		proRetVal = update_profile(@resume)
		flash[:notice] = proRetVal ? "Profile updated; " 	: "Error updating profile"
		if params["ajax"]
			render :json => {:retVal => "updated" }
		else	
			redirect_to session[:return_to]		
		end	
	end
	
	# DELETE destroy/:title/profiles
	def destroy
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@profile = @resume.profile
		result 	= @profile.destroy
		flash[:notice] = result ? "Profile destroyed" : "Error destroying resume"  
		if params["ajax"]
			render :json => {:retVal => "deleted" }
		else
			redirect_to '/show/'+@resume.title	
		end	
	end
end
