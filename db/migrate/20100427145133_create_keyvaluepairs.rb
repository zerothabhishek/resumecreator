class CreateKeyvaluepairs < ActiveRecord::Migration
  def self.up
    create_table :keyvaluepairs do |t|
      t.string :key
      t.text :value
      t.integer :prev
      t.integer :next
      t.references :subpart

      t.timestamps
    end
  end

  def self.down
    drop_table :keyvaluepairs
  end
end
