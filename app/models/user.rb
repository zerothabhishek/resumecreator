class User < ActiveRecord::Base
	has_many :resumes
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
end