class ResumesController < ApplicationController

  before_filter :check_session, :except => [:show]
  
  # GET /resumes
  def index
    # show a list of all recent resumes created. Expand the latest one
	@user = User.current
	@resumes = @user.resumes.all(:order => "updated_at DESC")
	@latest_resume = @resumes.first
  end
	
  # GET /resume/:id
  def show
    # This action may be externally exposed.
	# Requests from /:userUrl/:label should be redirected here after appropriate checks
	@resume = Resume.find(params[:id])
  end
	
  # GET /resumes/new
  def new
    @user = current_user
	@resume = Resume.new
  end
	
  # POST /resumes
  def create
    @resume = Resume.create!(params)
    redirect_to edit_resume_path(@resume)
  end

  # GET /resumes/:id/edit
  def edit
    @resume = current_user.resumes.find(params[:id])
    #session[:current_resume_id] = @resume.id
    #@parts_titles_list = PART_TITLES_ALL
  end
	
  # PUT /resumes/:id
  def update
    @resume = current_user.resumes.find(params[:id])
    resume_hash = params[:resume]
    @resume.update(resume_hash)
  end	
	
  # DELETE /resumes/:id
  def destroy
    @resume = current_user.resumes.find(params[:title])	
    @resume.destroy	
  end
  
end
