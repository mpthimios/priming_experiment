class ChangeMovieFormatIdRatings < ActiveRecord::Migration
  def change  	
	change_column :ratings, :movie_id, :string	
  end
end
