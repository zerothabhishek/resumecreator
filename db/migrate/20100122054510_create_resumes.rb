class CreateResumes < ActiveRecord::Migration
  def self.up
    create_table :resumes do |t|
      t.string :title
      t.string :name
      t.text :contact
      t.text :profile
      t.text :hobbies
      t.text :achievements
      t.string :public_status
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :resumes
  end
end
