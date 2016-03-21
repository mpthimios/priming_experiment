class AddStoryKeywordsToRatings < ActiveRecord::Migration
  def change
  	add_column :ratings, :story_keywords, :text
  end
end
