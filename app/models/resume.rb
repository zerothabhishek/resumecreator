class Resume < ActiveRecord::Base
  belongs_to :user
  #belongs_to :template
  has_one :contact
  has_one :profile
  has_many :educations
  has_many :experiences
  has_one :hobby
  has_one :achievement
  has_many :skills

#  def self.update_timestamp
#	retVal	= update_attributes({"updated_at" => DateTime.now()})
#	if  !retVal
#		logger.warn "Warning: problem updating resume timestamp"
#	end
#	return
#  end

end
