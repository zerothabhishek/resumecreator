class KeyvaluepairsController < ApplicationController
  before_filter :check_session

  # GET /parts/:part_id/keyvaluepairs
  def index  
    @part = Part.find(params[:part_id], :include => :keyvalurpairs)
  end
  
  # GET /parts/:part_id/keyvaluepairs/:id
  def show
    @part = Part.find(params[:part_id])
	@kvp = @part.keyvaluepairs.find(params[:id])
  end

  # GET /parts/:part_id/keyvaluepairs/new
  def new
    @part = Part.find(params[:part_id])
    @kvp = @part.keyvaluepairs.new
  end
  
  # POST /parts/:part_id/keyvaluepairs
  def create
    @part = Part.find(params[:part_id])
	@kvp = Keyvaluepair.create(params[:id])
	redirect_to part_keyvaluepair_path(@part, @kvp)
  end
  
  # GET /parts/:part_id/keyvaluepairs/:id/edit
  def edit
    @part = Part.find(params[:part_id])
    @kvp = @part.keyvaluepairs.find(params[:id])
  end
  
  # PUT /parts/:part_id/keyvaluepairs/:id
  def update
    @part = Part.find(params[:part_id])
	@kvp = Keyvaluepair.create(params[:id])
	@kvp.update_attributes(param[:keyvaluepair])
	redirect_to part_keyvaluepair_path(@part, @kvp)
  end
  
  # DELETE parts/:part_id/keyvaluepairs/:id
  def destroy
    @part = Part.find(params[:part_id])
	@kvp = Keyvaluepair.create(params[:id])
	redirec_to part_path(@part)
  end

end
