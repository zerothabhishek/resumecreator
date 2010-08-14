class AddPdftimestampToResume < ActiveRecord::Migration
  def self.up
	add_column :resumes, :pdf_timestamp, :datetime
  end

  def self.down
	remove_column :resumes, :pdf_timestamp
  end
end
