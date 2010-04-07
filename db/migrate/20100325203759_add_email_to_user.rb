class AddEmailToUser < ActiveRecord::Migration
  def self.up
	add_column :users, :email_id, :string
  end

  def self.down
	remove_column :email_id
  end
end
