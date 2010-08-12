module ResumesHelper

	def index_url
		"/index"
	end
	
	def home_url
		"/home"
	end
	
	def new_resume_url
		"/new"
	end
	
	def logout_url
		"/logout"
	end

	def dashboard_url
		"/dashboard/#{@resume.title}"	if @resume
	end

	def edit_url
		"/edit/#{@resume.title}"		if @resume
	end
	
	def preview_url
		"/view/#{@resume.title}" 		if @resume
	end

	def rtemplate_url
		"/rtemplate/#{@resume.title}"	if @resume
	end
	
	def publish_url
		"/publish/#{@resume.title}"		if @resume
	end
	
	def delete_url
		"/destroy/#{@resume.title}"		if @resume
	end
	
	def options_url
		"/options/#{@resume.title}"		if @resume
	end
	
end
