class AddTypeToUser < ActiveRecord::Migration
  def self.up
	add_column :users, :user_type, :string, :default => 'REGULAR'
  end

  def self.down
	remove_column :user_type
  end
end
