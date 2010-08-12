class EducationsController < ApplicationController

	before_filter :check_session,			# filter routine (applied before the action starts) checks for session
		:only => [:show, :new, :create, :destroy, :edit, :update] 	# actions where filter is applied

	# GET show/:title/educations
	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@educations = @resume.educations.all	
		session[:return_to] = "/show/"+@resume.title+"/educations"
	end
	
	# GET new/:title/educations
	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
	end

	# POST create/:title/educations
	def create
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@education = @resume.educations.build(params[:education])
		return_val = @education.save
		if return_val
			update_timestamp(@resume)
		end			
		flash[:notice] = return_val ? "Education instance created" : "Error saving education"
		if params["ajax"]
			if return_val
				render :json => { :retVal => "created", "id" => @education.id }
			else
				render :json => { :retVal => "error creating" }				
			end
		else
			redirect_to session[:return_to]
		end
	end
	
	
	# POST destroy/:title/educations/
	def destroy
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@education = @resume.educations.find(params["id"])	
		retStr = @education.destroy ? "deleted" : "Error deleting"
		render :json => {:retVal => retStr }
	end

	# POST destroyall/:title/educations/
	def destroyall
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		flash[:notice] = ""
		for education in @resume.educations
			eduId = education.id
			eduRetVal = education.destroy
			if eduRetVal	
				flash[:notice] += (" deleted_education:" + eduId.to_s)
			else			
				flash[:notice] += (" error_deleting:"	+ eduId.to_s)
			end
		end
		redirect_to session[:return_to]
	end
	
	# GET edit/:title/educations
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@educations = @resume.educations.all		
	end	
	
	# GET edit2/:title/educations
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])			
		@educations = @resume.educations.all		
	end	
	
	# PUT update/:title/educations
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
end
