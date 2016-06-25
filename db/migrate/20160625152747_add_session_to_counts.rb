class AddSessionToCounts < ActiveRecord::Migration
  def change
  	add_column :counts, :session_id, :string
  end
end
