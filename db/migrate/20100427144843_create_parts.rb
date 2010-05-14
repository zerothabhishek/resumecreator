class CreateParts < ActiveRecord::Migration
  def self.up
    create_table :parts do |t|
      t.string :title
      t.string :heading
      t.text :meta_desc
      t.integer :prev
      t.integer :next

      t.timestamps
    end
  end

  def self.down
    drop_table :parts
  end
end
