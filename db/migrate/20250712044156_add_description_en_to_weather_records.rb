class AddDescriptionEnToWeatherRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :weather_records, :description_en, :string
  end
end
