class UsersController < ApplicationController

	before_filter :check_session,			# filter routine (applied before the action starts) checks for session
		:only => [:logout, :set_as_default] 	# actions where filter is applied


	# POST /login
	def login
		user = User.authenticate(params[:username],params[:password])
		if user
			session[:current_user_id] = user.id
			flash[:notice] = "logged in"
			redirect_to '/home'
		else
			flash[:notice] = "Wrong username/password"
			redirect_to '/index'
		end
	end

	# POST /logout
	def logout
		@user = User.find(session[:current_user_id])
		session[:current_user_id] = nil
		if @user.user_type == 'TRIAL'		# delete the account if its a trial account (only account is deleted, not the resumes)
			result = @user.destroy
			if !result
				logger.error "Error: Trial account not deleted successfully"
			end
		end
		redirect_to '/index'
	end

	# POST /set_default_resume
	def set_default_resume
		@user = User.find(session[:current_user_id])
		@user.default_resume = params["resume_id"]
		result = @user.save
		if (params["ajax"]=="true")
			if result
					render :json => { :retVal => "set" }
			else
					render :json => { :retVal => "error"}
			end
		else
			redirect_to root_url
		end
	end

	# GET /signup
	def signup
		# just show the template- signup.html.erb
		if flash[:error] == "001"
			@error_msg = flash[:notice]
		end
		render :layout => "resumes.html.erb"
	end

	# POST /user/create
	def create
		username = params[:user]["username"]
		result = User.is_present(username)
		if result
			# the name already exists
			flash[:notice] = "username unavailable"
			flash[:error] = "001"
			redirect_to '/signup'
			return
		else
			@user = User.new(params[:user])
			result = @user.save
			if result
				flash[:notice] = "created"
				# log the user in and redirect to home
				session[:current_user_id] = @user.id
				redirect_to '/home'
			else
				flash[:notice] = "account creation failed"
				redirect_to '/signup'
			end
		end
	end

	# POST /user/check_availability
	def check_availability
		username = params["username"]
		result = User.is_present(username)
		if result
			render :json => { :retVal => "not available" }
		else
			render :json => { :retVal => "available" }
		end
	end

	# GET /trial
	def trial
		# create a temp user
		@user = User.new(:username => "trialUser", :user_type => "TRIAL")
		result1 = @user.save
		if !result1
			flash[:notice] = "some error"
			logger.error "Error: creating trial user"
			redirect_to '/index'
		end

		# create a trial resume for the user
		@resume = @user.resumes.build(:title => "trialResume", :name => "trialUser")
		result2 = @resume.save
		if !result2
			flash[:notice] = "some error"
			logger.error "Error: creating trial user"
			redirect_to '/index'
		end

		# log the user in, by settting the session
		session[:current_user_id] = @user.id

		# redirect the user to canvas page
		redirect_to '/edit/trialResume'
	end
end

