class CreateRtemplates < ActiveRecord::Migration
  def self.up
    create_table :rtemplates do |t|
      t.string :name
      t.text :desc
      t.string :author
      t.string :location
      t.string :thumbnail_url

      t.timestamps
    end
  end

  def self.down
    drop_table :rtemplates
  end
end
