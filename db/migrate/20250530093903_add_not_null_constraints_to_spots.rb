class AddNotNullConstraintsToSpots < ActiveRecord::Migration[7.2]
  def change
    change_column_null :spots, :name, false
    change_column_null :spots, :visit_status, false
    change_column_null :spots, :address, false
    change_column_null :spots, :latitude, false
    change_column_null :spots, :longitude, false
  end
end
