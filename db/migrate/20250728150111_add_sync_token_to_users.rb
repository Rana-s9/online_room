class AddSyncTokenToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :sync_token, :string
  end
end
