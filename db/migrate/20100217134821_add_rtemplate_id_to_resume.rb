class AddRtemplateIdToResume < ActiveRecord::Migration
  def self.up
  	add_column :resumes, :rtemplate_id, :integer, :default =>1
  end

  def self.down
	remove_column :resumes, :rtemplate_id
  end
end
