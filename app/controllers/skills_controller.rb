class SkillsController < ApplicationController

	before_filter :check_session,			# filter routine (applied before the action starts) checks for session
		:only => [:show, :new, :create, :destroy, :edit, :update] 	# actions where filter is applied

	# GET show/:title/skills
	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@skills = @resume.skills.all(:order => "skillset_type")
		session[:return_to] = "/show/"+@resume.title+"/skills"
	end

	# GET new/:title/skills
	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
	end

	# POST create/:title/skills
	def create
		# Data send in by the form is supposed to contain multiple (by default 3) skillsets
		# Hence the skillset creation (build and save) is being done in a loop
		# The loop runs as long as there are skillsets in the POSTed data
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])

		if params["ajax"] == "true"	# ajax requests have one skillset
			@skillset = @resume.skills.build(params[:skill])
			return_val = @skillset.save
			if return_val
				update_timestamp(@resume)
				render :json => { :retVal => "created", "id" => @skillset.id }
			else
				render :json => { :retVal => "error creating" }
			end
		else				# Non-ajax requests have multiple skillsets
			skillData = params[:skills]
			count = 0
			flash[:notice] = ""
			while skillRow = skillData[count.to_s]
				count +=1
				@skillset = @resume.skills.build(skillRow)
				return_val = @skillset.save
				if !return_val
					flash[:notice] += "Error_creating_skillset;"
					next
				end
				update_timestamp(@resume)
				flash[:notice] += "Skillset_created;"
			end
			redirect_to session[:return_to]
		end
	end

	# POST destroy/:title/skills
	def destroy
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@skill = @resume.skills.find(params["id"])
		retStr = @skill.destroy ? "deleted" : "Error deleting"
		render :json => {:retVal => retStr }
	end

	# POST destroyall/:title/skills
	def destroyall
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		for skill in @resume.skills
			skillId = skill.id
			skillRetVal = skill.destroy
			if skillRetVal
				flash[:notice] += (" deleted_skillset:" + skillId.to_s)
			else
				flash[:notice] += (" error_deleting_skillset:" + skillId.to_s)
			end
		end
		redirect_to session[:return_to]
	end

	# GET /edit/:title/skills
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@skills = @resume.skills.all
	end

	# GET /edit2/:title/skills
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@skills = @resume.skills.all
	end

	# PUT /update/:title/skills
	def update
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		skiRetVal = update_skills(@resume)
		flash[:notice] += skiRetVal ? "Skills updated; " : "Error updating skills"
		if params["ajax"]
			render :json => {:retVal => "updated" }
		else
			redirect_to session[:return_to]
		end

	end
end
