class AddNextSyncTokenToCalendars < ActiveRecord::Migration[7.2]
  def change
    add_column :calendars, :next_sync_token, :string
  end
end
