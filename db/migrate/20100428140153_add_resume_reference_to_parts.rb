class AddResumeReferenceToParts < ActiveRecord::Migration
  def self.up
	add_column :parts, :resume_id, :integer
  end

  def self.down
	remove_column :parts, :resume_id
  end
end
