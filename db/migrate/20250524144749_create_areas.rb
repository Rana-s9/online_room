class CreateAreas < ActiveRecord::Migration[7.2]
  def change
    create_table :areas do |t|
      t.references :user, null: false, foreign_key: true

      t.string :city
      t.timestamps
    end
  end
end
