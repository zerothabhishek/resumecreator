class ContactsController < ApplicationController

	before_filter :check_session,	# filter routine (applied before the action starts) checks for session
		:only => [:show, :new, :create, :edit, :update]

	# GET /show/:title/contacts
	def show
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@contact = @resume.contact
		session[:return_to] = '/show/'+@resume.title+'/contacts'
	end	
		
	# GET /new/:title/contacts
	def new
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
	end
	
	# POST /create/:title/contacts
	def create
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@contact = @resume.build_contact(params[:contact])
		result = @contact.save
		if result
			update_timestamp(@resume)
		end			
		if params["ajax"]=="true"
			if result
				render :json => { :retVal => "created", "id" => @contact.id }
			else
				render :json => { :retVal => "error creating" }
			end
		else
			flash[:notice] = result ? "Contact created" : "Error creating contact"
			redirect_to session[:return_to]
		end
	end
	
	# GET /edit/:title/contacts
	def edit
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@contact = @resume.contact		
	end

	# GET /edit2/:title/contacts
	def edit2
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		@contact = @resume.contact		
	end
	
	# PUT update/:title/contacts
	def update
		@user = User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])
		conRetVal = update_contact(@resume)					# Update the contact
		flash[:notice] = conRetVal ? "Contact updated; " : "Error updating contact" 
		if params["ajax"]
			render :json => {:retVal => "updated" }
		else
			redirect_to session[:return_to]		
		end	
	end
	
	# DELETE destroy/:title/contacts
	def destroy
		@user 	= User.find(session[:current_user_id])
		@resume = @user.resumes.find(:first, :conditions => ["title =?",params[:title]])	
		@contact = @resume.contact
		result 	= @contact.destroy
		flash[:notice] = result ? "Contact destroyed" : "Error destroying resume"  
		if params["ajax"]
			render :json => {:retVal => "deleted" }
		else
			redirect_to '/show/'+@resume.title	
		end
	end
end
