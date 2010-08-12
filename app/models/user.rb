class User < ActiveRecord::Base
	has_many :resumes
	has_many :parts
	has_many :keyvaluepairs
	
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