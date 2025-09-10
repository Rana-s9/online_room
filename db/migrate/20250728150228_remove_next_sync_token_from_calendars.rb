class RemoveNextSyncTokenFromCalendars < ActiveRecord::Migration[7.2]
  def change
    remove_column :calendars, :next_sync_token, :string
  end
end
