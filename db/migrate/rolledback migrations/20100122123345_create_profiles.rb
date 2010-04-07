class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.text :profile_text
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
