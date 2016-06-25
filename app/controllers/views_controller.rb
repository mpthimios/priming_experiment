class ViewsController < ApplicationController

  def introduction

  end

  def story
    count = Count.order('created_at DESC').first
    if count.nil?
      count = Count.new
      count.count = 0
      count.session_id = session.id
      count.save
    else
      new_count = Count.new
      new_count.count = count.count+1
      new_count.session_id = session.id
      new_count.save      
    end
    action = new_count.count % 2
    logger.debug action
    if action ==1 
      redirect_to get_preferences_path
    else
      redirect_to get_movies_path
    end
    
  end

  def story_description
  	if session[:story].nil?
  		redirect_to index_path
  	end
  end

  def movies
    if !params[:preferences].nil? && !params[:original_genre_list].nil?
      session[:preferences] = params[:preferences]
      session[:original_genre_list] = params[:original_genre_list]
    end
    @movies=Movie.order('rand()')
    if request.post?
      @action_id = 2      
    else
      @action_id = 1
    end    	    
  end

  def preferences
    if !params[:ratings].nil? && !params[:movie_preferences].nil?
      session[:ratings] = params[:ratings]
      session[:movie_preferences] = params[:movie_preferences]
    end
    if request.post?
      @action_id = 2      
    else
      @action_id = 1
    end        
  end

  def thank_you  	
  	if (!params[:ratings].nil? && !params[:movie_preferences].nil? && !session[:preferences].nil? && !session[:original_genre_list].nil?) 
      logger.debug "coming from movies"
      logger.debug params[:ratings]
      logger.debug session[:preferences]
      process_ratings(params)
      process_preferences(session)
      process_movie_preferences(params)
      original_genre_list(session)
      @mturk_code = generate_mturk_code
    elsif (!session[:ratings].nil? && !session[:movie_preferences].nil? && !params[:preferences].nil? && !params[:original_genre_list].nil?)
      logger.debug "preferences"
      logger.debug params[:ratings]
      logger.debug session[:ratings]
      logger.debug session[:movie_preferences]
      logger.debug session[:original_genre_list]
      process_ratings(session)
      process_preferences(params)
      process_movie_preferences(session)
      original_genre_list(params)
      @mturk_code = generate_mturk_code
    else
      redirect_to index_path
    end    
    session.delete(:preferences)
    session.delete(:ratings)
    session.delete(:movie_preferences)
    session.delete(:original_genre_list)    
  end

  private

  def generate_mturk_code
    mturk_code = (0...8).map { (65 + rand(26)).chr }.join
    code = Code.new
    code.session_id = session.id            
    code.mturk_code = mturk_code
    code.save
    mturk_code
  end

  def process_ratings (params)
    ratings = JSON.parse params[:ratings]   
    ratings.each do |rating|      
      key, value = rating.first        
      logger.debug key
      logger.debug value
      logger.debug session.id
      new_rating = Rating.new(:movie_id => key, :story_id => session[:story], :session_id => session.id, 
        :rating => value, :would_watch => 1,
        :story_type => session[:story_type], :story_keywords => session[:keywords])
      new_rating.save
    end
  end

  def process_preferences (params)
      preferences = params[:preferences]   
      new_preferences = Preference.new(:session_id => session.id, :preference => preferences, :preference_type => 'genres')
      new_preferences.save
  end

  def process_movie_preferences (params)
      movie_preferences = params[:movie_preferences]   
      new_preferences = Preference.new(:session_id => session.id, :preference => movie_preferences, :preference_type => 'movies')
      new_preferences.save
  end

  def original_genre_list (params)
      original_genre_list = params[:original_genre_list]   
      new_preferences = Preference.new(:session_id => session.id, :preference => original_genre_list, :preference_type => 'original_genre_list')
      new_preferences.save
  end
end
