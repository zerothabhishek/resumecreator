class CreateEducations < ActiveRecord::Migration
  def self.up
    create_table :educations do |t|
      t.string :level
      t.string :major
      t.string :score
      t.string :college
      t.text :more_info
      t.references :resume

      t.timestamps
    end
  end

  def self.down
    drop_table :educations
  end
end
