class AddIndexToAreasUserId < ActiveRecord::Migration[7.2]
  def change
    remove_index :areas, name: "index_areas_on_user_id"
    add_index :areas, :user_id, unique: true
  end
end
