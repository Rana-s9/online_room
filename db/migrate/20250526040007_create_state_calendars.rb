class CreateStateCalendars < ActiveRecord::Migration[7.2]
  def change
    create_table :state_calendars do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.string :mental_state
      t.string :physical_state
      t.timestamps
    end
  end
end
