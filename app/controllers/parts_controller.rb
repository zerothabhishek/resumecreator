class PartsController < ApplicationController
  before_filter :check_session

  # GET /parts/new
  def new
    @part = Part.new
  end
  
  # POST /parts
  def create
    @part = Part.create!(params_hash)
	# redirect after checking if its an AJAX request
  end
  
  # GET /parts/:id/edit
  def edit
    @part = current_user.parts.find(params[:id])
  end
  
  # PUT /parts/:id
  def update
    @part = current_user.parts.find(params[:id])
	part_hash = params[:part]
    @part.update(part_hash)
  end
  
  # DELETE /parts/:id
  def destroy
    @part = current_user.parts.find(params[:id])
	@part.destroy
  end



	# POST create2/part
	def create2
		begin
			@user = User.find(session[:current_user_id])
			@resume = @user.resumes.find(session[:current_resume_id])
			
			part_obj = Part.create_by_title(params[:new_part_title])
			@resume.parts << part_obj									# add the newly created part to the resume
			@resume.save												# save the resume - saves the parts, subparts and keyvaluepairs too		
			
			render :partial => "parts/show", :locals => { :part => part_obj }
		end
	end
	
end
