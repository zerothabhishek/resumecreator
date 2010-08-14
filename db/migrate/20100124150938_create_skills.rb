class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.string :skill_name
      t.string :skill_remarks
      t.string :skillset_type
      t.references :resume

      t.timestamps
    end
  end

  def self.down
    drop_table :skills
  end
end
