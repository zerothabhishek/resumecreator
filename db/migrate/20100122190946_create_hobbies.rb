class CreateHobbies < ActiveRecord::Migration
  def self.up
    create_table :hobbies do |t|
      t.text :hobbies_text
      t.references :resume

      t.timestamps
    end
  end

  def self.down
    drop_table :hobbies
  end
end
