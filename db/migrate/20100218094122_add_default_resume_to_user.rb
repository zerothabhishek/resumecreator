class AddDefaultResumeToUser < ActiveRecord::Migration
  def self.up
	add_column :users, :default_resume, :integer
  end

  def self.down
	remove_column :users, default_resume
  end
end
