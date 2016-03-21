class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.text :session_id
      t.text :preference

      t.timestamps null: false
    end
  end
end
