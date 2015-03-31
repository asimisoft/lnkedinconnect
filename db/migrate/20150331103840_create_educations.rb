class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :college
      t.string :degree
      t.string :field
      t.string :graduation_year
      t.integer :profile_id
      t.timestamps
    end
  end
end