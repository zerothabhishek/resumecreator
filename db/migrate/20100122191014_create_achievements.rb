class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.text :achievements_text
      t.references :resume

      t.timestamps
    end
  end

  def self.down
    drop_table :achievements
  end
end
