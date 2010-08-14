class StaticPagesController < ApplicationController

	def show
		set_urls(nil)
		render :template => "static_pages/#{params[:page]}.html.erb", :layout => 'resumes'
	end

end
