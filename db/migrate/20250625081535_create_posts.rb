class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true

      t.integer :relationship, null: false
      t.string :custom_relationship

      t.integer :post_type, null: false

      t.integer :situation, null: false
      t.string :custom_situation

      t.text :content, null: false

      t.integer :display_name, null: false, default: 0
      t.string :custom_name
      t.timestamps
    end
  end
end
