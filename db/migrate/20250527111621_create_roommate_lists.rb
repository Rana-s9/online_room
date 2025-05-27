class CreateRoommateLists < ActiveRecord::Migration[7.2]
  def change
    create_table :roommate_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.timestamps
    end
  end
end
