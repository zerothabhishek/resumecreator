class HobbiesController < ApplicationController
	before_filter :check_session,			# filter routine (applied before the action starts) checks for session
		:only => [:show, :new, :create, :edit, :update]		# filter applied on these actions

	# GET /show/:title/hobbies
	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@hobby = @resume.hobby
		session[:return_to] = '/show/'+@resume.title+'/hobbies'
	end	
		
	# GET /new/:title/hobbies
	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
	end
	
	# POST /create/:title/hobbies
	def create
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@hobby = @resume.build_hobby(params[:hobby])
		result = @hobby.save
		if result
			update_timestamp(@resume)
		end	
		if params["ajax"]=="true"
			if result
				render :json => { :retVal => "created", "id" => @hobby.id }
			else
				render :json => { :retVal => "error creating" }
			end
		else
			flash[:notice] = result ? "Hobby created" : "Error creating hobby"
			redirect_to session[:return_to]
		end
	end
	
	# GET /edit/:title/hobbies
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@hobby = @resume.hobby
	end

	# GET /edit2/:title/hobbies
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@hobby = @resume.hobby
	end
	
	# PUT /update/:title/hobbies
	def update
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		hobRetVal = update_hobby(@resume)					# Update the hobby
		flash[:notice] = hobRetVal ? "Hobby updated " : "Error updating hobby"
		if params["ajax"]
			render :json => {:retVal => "updated" }
		else	
			redirect_to session[:return_to]		
		end 
	end

	# DELETE destroy/:title/hobbies
	def destroy
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@hobby = @resume.hobby
		result 	= @hobby.destroy
		flash[:notice] = result ? "Hobby destroyed" : "Error destroying resume"  
		if params["ajax"]
			render :json => {:retVal => "deleted" }
		else
			redirect_to '/show/'+@resume.title	
		end	
	end	
end
