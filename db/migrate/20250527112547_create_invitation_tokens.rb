class CreateInvitationTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :invitation_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.string :token, null: false

      t.datetime :used_at
      t.datetime :expires_at
      t.integer :invited_user

      t.timestamps
    end
  end
end
