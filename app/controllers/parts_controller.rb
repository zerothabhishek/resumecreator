class PartsController < ApplicationController
  before_filter :authenticate

  # GET /resumes/:resume_id/parts
  def index
	@resume = current_user.find(params[:resume_id], :include => :parts)
  end
  
  # GET /resumes/:resume_id/parts/:id
  def show
    @part = Part.find(params[:id])
  end
  
  # GET /resumes/:resume_id/parts/new
  def new
    @resume = current_user.resumes.find(params[:resume_id])
	@part = @resume.parts.new
  end
  
  # POST /resumes/:resume_id/parts
  def create
    @resume = current_user.resumes.find(params[:resume_id])
	@part = Part.create(params[:part])
	redirect_to resume_part_path(@resume, @part)
  end
  
  # GET /resumes/:resume_id/parts/:id/edit
  def edit
    @resume = current_user.resumes.find(params[:resume_id])
    @part = @resume.parts.find(params[:id])
  end
  
  # PUT /resumes/:resume_id/parts/:id
  def update
    @resume = current_user.resumes.find(params[:resume_id])
    @part = @resume.parts.find(params[:id])
    @part.update_attributes(params[:part])
  end
  
  # DELETE /resumes/:resume_id/parts/:id
  def destroy
    @resume = current_user.resumes.find(params[:resume_id])
    @part = @resume.parts.find(params[:id])
	@part.destroy
	redirect_to resume_path(@resume)
  end
	
end
