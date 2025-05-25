class AddIndexWeatherRecordsOnAreaId < ActiveRecord::Migration[7.2]
  def change
    remove_index :weather_records, name: "index_weather_records_on_area_id"
    add_index :weather_records, :area_id, unique: true
  end
end
