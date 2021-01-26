class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[show edit update destroy]

  def index
    tweet = current_user.tweet.detect do |t|
      params[:select] == t.name
    end

    config = {
      consumer_key: tweet&.key,
      consumer_secret: tweet&.secret,
      access_token: tweet&.token,
      access_token_secret: tweet&.token_secret
    }
    client = Twitter::REST::Client.new config

    if params[:select_action] == 'follow' ||
       params[:select_action] == 'unfollow' ||
       params[:select_action] == 'follow-hands'
      followers = Twi.get_followers(client, config)
      followers_total = Twi.get_followers_total(followers)
      friends_total = Twi.get_friends(client, config)
    elsif params[:select_action] == 'acc-parsering'
      user_id = params['tag']
      followers = Twi.get_followers(client, user_id)
    elsif params[:select_action] == 'retweeting'
      sclient = Twitter::Streaming::Client.new(config)
    end

    case params[:select_action]
    when 'follow'
      follow = followers_total - friends_total
      Twi.follow(client, follow)
      flash[:notice] = 'Success'
    when 'unfollow'
      unfollow = friends_total - followers_total
      Twi.unfollow(client, unfollow)
      flash[:notice] = 'Success'
    when 'retweeting'
      topics = params['tag'].split(/,/)
      Twi.retweet(client, sclient, topics)
      flash[:notice] = 'Success'
    when 'posting'
      array_posts = params[:tag1].split(/[\r\n]+/)
      Twi.post(client, array_posts)
      flash[:notice] = 'Success'
    when 'parsering'
      twi_acc = params['tag']
      twits_array = Twi.parser(client, twi_acc).join('<br>')
      flash[:notice] = twits_array
    when 'acc-parsering'
      twi_array = Twi.print_followers(followers).join(' ')
      flash[:notice] = twi_array
    when 'follow-hands'
      array = []
      follow = followers_total - friends_total
      follow.take(20).each do |user|
        array << '<a href = https://twitter.com/' +
                 user.screen_name +
                 ' target="_blank">' +
                 user.screen_name +
                 '</a>'
      end
      flash[:notice] = if array.empty?
                         'Nothing to do'
                       else
                         array.join('<br>')
                       end
    end
  end

  def show
    @tweet = current_user.tweet.find_by(id: params[:id])
  end

  def new
    @tweet = current_user.tweet.build
  end

  def create
    @tweet = current_user.tweet.build(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:name, :key, :secret, :token, :token_secret, :user_id)
  end
end
