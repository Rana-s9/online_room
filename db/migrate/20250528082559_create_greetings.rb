class CreateGreetings < ActiveRecord::Migration[7.2]
  def change
    create_table :greetings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.string :message, null: false
      t.integer :greeting_type, null: false
      t.timestamps
    end
  end
end
