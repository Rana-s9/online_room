class CreateReads < ActiveRecord::Migration[7.2]
  def change
    create_table :reads do |t|
      t.references :user, foreign_key: true
      t.references :exchange_diary, foreign_key: true
      t.timestamps
    end
    add_index :reads, [ :user_id, :exchange_diary_id ], unique: true
  end
end
