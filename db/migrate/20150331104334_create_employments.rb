class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.string :company
      t.string :position
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :current
      t.text :description
      t.integer :profile_id
      t.timestamps
    end
  end
end
