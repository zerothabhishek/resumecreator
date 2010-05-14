class CreateSubparts < ActiveRecord::Migration
  def self.up
    create_table :subparts do |t|
      t.string :title
      t.text :meta_desc
      t.integer :prev
      t.integer :next
      t.references :part

      t.timestamps
    end
  end

  def self.down
    drop_table :subparts
  end
end
