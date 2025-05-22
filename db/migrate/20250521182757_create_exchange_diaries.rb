class CreateExchangeDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :exchange_diaries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.text :body
      t.timestamps
    end
  end
end
