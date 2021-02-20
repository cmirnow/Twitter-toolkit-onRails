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
    when 'follow'
      FollowJob.perform_later(tweet)
      message
    when 'unfollow'
      UnfollowJob.perform_later(tweet)
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
      message GetAccountsJob.perform_now(tweet, params['tag'])
                            .to_s.gsub('"', '')
                            .tr('[]', '')
    when 'follow-hands'
      follow = FollowHandsJob.perform_now(tweet)
      # Select the number of accounts to follow manually:
      result = follow.first(20).map do |user|
        helpers.link_to user.screen_name,
                        "https://twitter.com/#{user.screen_name}",
                        target: '_blank'
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
