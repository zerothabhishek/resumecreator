class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.text :address
      t.string :phone_nos
      t.string :emails
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
