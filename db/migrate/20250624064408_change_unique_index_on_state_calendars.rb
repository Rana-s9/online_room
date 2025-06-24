class ChangeUniqueIndexOnStateCalendars < ActiveRecord::Migration[7.2]
  def change
    remove_index :state_calendars, name: "index_state_calendars_on_user_id_and_date"
    add_index :state_calendars, [ :user_id, :room_id, :date ], unique: true, name: "index_state_calendars_on_user_room_date"
  end
end
