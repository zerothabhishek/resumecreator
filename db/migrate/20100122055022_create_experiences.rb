class CreateExperiences < ActiveRecord::Migration
  def self.up
    create_table :experiences do |t|
      t.string :title
      t.string :company
      t.string :duration
      t.text :role
      t.text :more_info
      t.references :resume

      t.timestamps
    end
  end

  def self.down
    drop_table :experiences
  end
end
