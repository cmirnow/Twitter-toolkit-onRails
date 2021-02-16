class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[show edit update destroy]

  def tweet
    current_user.tweet.detect do |t|
      params[:select] == t.name
    end
  end

  def index
    case params[:select_action]
    when 'follow', 'unfollow', 'follow-hands'
      followers = GetFollowersJob.perform_now(tweet)
      friends = GetFriendsJob.perform_now(tweet)
    when 'acc-parsering'
      followers = GetFollowersJob.perform_now(tweet, params['tag'])
    end

    case params[:select_action]
    when 'follow'
      follow = (followers - friends).as_json(only: %i[id screen_name])
      FollowJob.perform_later(tweet, follow)
      message
    when 'unfollow'
      unfollow = (friends - followers).as_json(only: %i[id screen_name])
      UnfollowJob.perform_later(unfollow, tweet)
      message
    when 'retweeting'
      topics = params['tag'].split(/,/)
      RetweetsJob.perform_later(topics, tweet)
      message
    when 'posting'
      array_posts = params[:tag1].split(/[\r\n]+/)
      PostingJob.perform_later(array_posts, tweet)
      message
    when 'parsering'
      message GetTweetsJob.perform_now(tweet, params['tag']).map { |n| n + '<br/>' }
                          .to_s
                          .gsub('", "', '')
                          .gsub('\"', '')
                          .gsub('\n', '')
                          .tr('[""]', '')
    when 'acc-parsering'
      message GetAccountsJob.perform_now(followers.as_json(only: [:screen_name]))
                            .to_s.gsub('"', '')
                            .tr('[]', '')
    when 'follow-hands'
      follow = followers - friends
      # Select the number of accounts to follow manually:
      result = follow.first(20).map do |user|
        '<a href = https://twitter.com/' +
          user.screen_name +
          ' target="_blank">' +
          user.screen_name +
          '</a>'
      end

      message x = if result.empty?
                    'Nothing to do'
                  else
                    result.join('<br>')
                  end
    end
  end

  def message(x = ('The task is queued ' + Time.now.to_s))
    respond_to do |format|
      format.json { render json: x }
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
