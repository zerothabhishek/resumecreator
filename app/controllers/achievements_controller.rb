class AchievementsController < ApplicationController

	before_filter :check_session,	# filter routine (applied before the action starts) checks for session
		:only => [:show, :new, :create, :edit] 	# actions where filter is applied

	# GET /show/:title/achievement
	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@achievement = @resume.achievement
		session[:return_to] = '/show/'+@resume.title+'/achievements'
	end

	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
	end

	def create
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@achievement = @resume.build_achievement(params[:achievement])
		result = @achievement.save
		if result
			update_timestamp(@resume)
		end
		if params["ajax"]=="true"
			if result
				render :json => { :retVal => "created", "id" => @achievement.id }
			else
				render :json => { :retVal => "error creating" }
			end
		else
			flash[:notice] = result ? "Achievement created" : "Error creating achievement"
			redirect_to session[:return_to]
		end
	end

	# GET /edit/:title/achievements
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@achievement = @resume.achievement
	end

	# GET /edit2/:title/achievements
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@achievement = @resume.achievement
	end

	# PUT /update/:title/achievements
	def update
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		achRetVal = update_achievement(@resume)				# Update the achievement
		flash[:notice] = achRetVal ? "Achievements updated; ": "Error updating achievements"
		if params["ajax"]
			render :json => {:retVal => "updated" }
		else
			redirect_to session[:return_to]
		end
	end

	# DELETE destroy/:title/achievements
	def destroy
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@achievement = @resume.achievement
		result 	= @achievement.destroy
		flash[:notice] = result ? "achievements destroyed" : "Error destroying resume"
		if params["ajax"]
			render :json => {:retVal => "deleted" }
		else
			redirect_to '/show/'+@resume.title
		end
	end
end
