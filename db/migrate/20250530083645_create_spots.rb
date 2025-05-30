class CreateSpots < ActiveRecord::Migration[7.2]
  def change
    create_table :spots do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.string :name
      t.integer :visit_status
      t.string :address
      t.float :latitude
      t.float :longitude
      t.date :date
      t.timestamps
    end
  end
end
