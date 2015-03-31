class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :location
      t.string :country
      t.string :filepicker_url
      t.string :resume_url
      t.text :skills
      t.string :phone
      t.string :status, :default => "Registered"
      t.integer :user_id
      t.text :summary

      t.timestamps
    end
  end
end
