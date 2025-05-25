class CreateWeatherRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :weather_records do |t|
      t.references :area, null: false, foreign_key: true

      t.float :temperature
      t.float :humidity
      t.string :description
      t.float :temp_min
      t.float :temp_max
      t.timestamps
    end
  end
end
