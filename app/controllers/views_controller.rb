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
    story_id = count.count % 5
    logger.debug story_id +1 
  	@story=Story.find_by id: story_id + 1
  	session[:story] = @story.id
  end

  def story_description
  	if session[:story].nil?
  		redirect_to index_path
  	end
  end

  def movies
  	if session[:story].nil? || params[:keywords] == "" || params[:story_type] == ""
  		redirect_to index_path
  	end
  	session[:keywords] = params[:keywords]
  	session[:story_type] = params[:story_type]
  	logger.debug params
  	@movies=Movie.all
  end

  def preferences
    if !params[:ratings].nil?
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
  end

  def thank_you  	
  	if !params[:genre].nil?
      params[:genre].each do |key, value|
        logger.debug key
        new_preference = Preference.new(:session_id => session.id, :preference => key)        
        new_preference.save
      end
      @mturk_code = (0...8).map { (65 + rand(26)).chr }.join
      code = Code.new
      code.session_id = session.id            
      code.mturk_code = @mturk_code      
      code.save      
    end
  end
end
