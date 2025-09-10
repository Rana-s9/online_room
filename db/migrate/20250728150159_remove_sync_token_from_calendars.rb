class RemoveSyncTokenFromCalendars < ActiveRecord::Migration[7.2]
  def change
    remove_column :calendars, :sync_token, :string
  end
end
