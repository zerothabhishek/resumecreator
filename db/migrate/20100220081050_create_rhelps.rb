class CreateRhelps < ActiveRecord::Migration
  def self.up
    create_table :rhelps do |t|
      t.string :rcontroller
      t.string :raction
      t.string :rview
      t.string :key
      t.text :msg

      t.timestamps
    end
  end

  def self.down
    drop_table :rhelps
  end
end
