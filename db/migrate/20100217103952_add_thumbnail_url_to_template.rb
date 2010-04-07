class AddThumbnailUrlToTemplate < ActiveRecord::Migration
  def self.up
	add_column :templates, :thumbnail_url, :string
  end

  def self.down
	remove_column :templates, :thumbnail_url, :string
  end
end
