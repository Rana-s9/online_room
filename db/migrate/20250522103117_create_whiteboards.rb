class CreateWhiteboards < ActiveRecord::Migration[7.2]
  def change
    create_table :whiteboards do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.text :body
      t.timestamps
    end
  end
end
