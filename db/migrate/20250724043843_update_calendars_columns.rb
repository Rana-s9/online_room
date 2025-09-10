class UpdateCalendarsColumns < ActiveRecord::Migration[7.2]
  def change
    if column_exists?(:calendars, :calendar_type)
      remove_column :calendars, :calendar_type
    end
    add_column :calendars, :source, :integer, null: false, default: 0
    add_column :calendars, :category, :integer
    rename_column :calendars, :all_day, :schedule_type
  end
end
