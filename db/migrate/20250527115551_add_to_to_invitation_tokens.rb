class AddToToInvitationTokens < ActiveRecord::Migration[7.2]
  def change
    change_column_null :invitation_tokens, :expires_at, false
    add_index :invitation_tokens, :token, unique: true
  end
end
