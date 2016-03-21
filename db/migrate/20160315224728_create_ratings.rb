class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :movie_id
      t.integer :story_id
      t.string :session_id
      t.integer :rating
      t.integer :would_watch

      t.timestamps null: false
    end
  end
end
