class AddStoryTypeToRatings < ActiveRecord::Migration
  def change
  	add_column :ratings, :story_type, :string
  end
end
