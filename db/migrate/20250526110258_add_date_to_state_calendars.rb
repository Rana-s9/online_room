class AddDateToStateCalendars < ActiveRecord::Migration[7.2]
  def change
    add_column :state_calendars, :date, :date
  end
end
