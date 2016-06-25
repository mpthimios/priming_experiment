class AddTypeToPreferences < ActiveRecord::Migration
  def change
  	add_column :preferences, :preference_type, :string
  end
end
