class ViewsController < ApplicationController

  def introduction

  end

  def story
    count = Count.first
    if count.nil?
      count = Count.new
      count.count = 0
      count.save
    else
      count.count = count.count+1
      count.save
    end
    action = count.count % 2
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
    if !params[:preferences].nil?
      session[:preferences] = params[:preferences]
    end
    @movies=Movie.order('rand()')
    if request.post?
      @action_id = 2      
    else
      @action_id = 1
    end    	    
  end

  def preferences
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    if request.post?
      @action_id = 2      
    else
      @action_id = 1
    end        
  end

  def thank_you  	
  	if (!params[:ratings].nil? && !session[:preferences].nil?) 
      logger.debug "coming from movies"
      logger.debug params[:ratings]
      logger.debug session[:preferences]
      process_ratings(params)
      process_preferences(session)
      @mturk_code = generate_mturk_code
    elsif (!session[:ratings].nil? && !params[:preferences].nil?)
      logger.debug "preferences"
      logger.debug params[:ratings]
      logger.debug session[:ratings]
      process_ratings(session)
      process_preferences(params)
      @mturk_code = generate_mturk_code
    else
      redirect_to index_path
    end    
    session.delete(:preferences)
    session.delete(:ratings)
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
      new_preferences = Preference.new(:session_id => session.id, :preference => preferences)
      new_preferences.save
  end
end
