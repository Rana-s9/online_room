class ChangeGoogleEventIdIndexOnCalendars < ActiveRecord::Migration[7.2]
  def change
    remove_index :calendars, name: "index_calendars_on_google_event_id"

    add_index :calendars, [ :room_id, :google_event_id ],
              unique: true,
              name: "index_calendars_on_room_id_and_google_event_id"
  end
end
