class MoreChangeResume < ActiveRecord::Migration
  def self.up
	add_column :resumes, :template_id, :integer, :default =>1
  end

  def self.down
	remove_column :resumes, :template_id
  end
end
