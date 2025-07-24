class CreateCalendars < ActiveRecord::Migration[7.2]
  def change
    create_table :calendars do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :all_day, null: false, default: 0
      t.integer :calendar_type, null: false, default: 0
      t.integer :visibility, null: false, default: 0

      t.string :google_calendar_id
      t.string :google_event_id
      t.datetime :last_synced_at
      t.string :sync_token

      t.timestamps null: false

      t.index :google_event_id, unique: true
    end
  end
end
