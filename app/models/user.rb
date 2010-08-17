class User < ActiveRecord::Base
  include Clearance::User
  has_many :resumes


  # Hooks for disabling email confirmation
  after_create :confirm_user 
  def deliver_confirmation_email 
   # Do Nothing 
   # or MyMailer.deliver_thank_you self 
  end 
  private 
  def confirm_user 
     self.update_attributes({:email_confirmed => true}) 
   end 
  end 
  # EndOfHooks
	
	def self.current
			
	end
	
	def self.authenticate(user, pass)
		u = find(:first, :conditions => ["username=? AND password=?", user, pass])
		return nil if u.nil?
		return u
	end	
	
	def self.is_present(username)
		u = find(:first, :conditions => ["username=?", username])
		return nil if u.nil?
		return u
	end
	
	def has_resume(resumeTitle)
		u = self.resumes.find_by_title(resumeTitle)
		return nil if u.nil?
		return u
	end
	
end