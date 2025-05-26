class AddUniqueIndexToStateCalendars < ActiveRecord::Migration[7.2]
  def change
    add_index :state_calendars, [ :user_id, :date ], unique: true
  end
end
