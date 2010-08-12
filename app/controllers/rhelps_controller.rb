class RhelpsController < ApplicationController
  # GET /rhelps
  # GET /rhelps.xml
  def index
    @rhelps = Rhelp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rhelps }
    end
  end

  # GET /rhelps/1
  # GET /rhelps/1.xml
  def show
    @rhelp = Rhelp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rhelp }
    end
  end

  # GET /rhelps/new
  # GET /rhelps/new.xml
  def new
    @rhelp = Rhelp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rhelp }
    end
  end

  # GET /rhelps/1/edit
  def edit
    @rhelp = Rhelp.find(params[:id])
  end

  # POST /rhelps
  # POST /rhelps.xml
  def create
    @rhelp = Rhelp.new(params[:rhelp])

    respond_to do |format|
      if @rhelp.save
        flash[:notice] = 'Rhelp was successfully created.'
        format.html { redirect_to(@rhelp) }
        format.xml  { render :xml => @rhelp, :status => :created, :location => @rhelp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rhelp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rhelps/1
  # PUT /rhelps/1.xml
  def update
    @rhelp = Rhelp.find(params[:id])

    respond_to do |format|
      if @rhelp.update_attributes(params[:rhelp])
        flash[:notice] = 'Rhelp was successfully updated.'
        format.html { redirect_to(@rhelp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rhelp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rhelps/1
  # DELETE /rhelps/1.xml
  def destroy
    @rhelp = Rhelp.find(params[:id])
    @rhelp.destroy

    respond_to do |format|
      format.html { redirect_to(rhelps_url) }
      format.xml  { head :ok }
    end
  end
end
