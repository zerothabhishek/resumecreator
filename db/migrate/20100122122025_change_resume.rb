class ChangeResume < ActiveRecord::Migration
  def self.up
	remove_column :resumes, :contact
	remove_column :resumes, :profile
	remove_column :resumes, :hobbies
	remove_column :resumes, :achievements
	add_column :resumes, :meta_desc, :text
  end

  def self.down
	add_column :resumes, :contact, :text
	add_column :resumes, :profile, :text
	add_column :resumes, :hobbies, :text
	add_column :resumes, :achievements, :text
	remove_column :resumes, :meta_desc  
  end
end
