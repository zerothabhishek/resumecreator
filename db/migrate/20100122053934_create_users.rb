class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password
      t.boolean :logon_status

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
