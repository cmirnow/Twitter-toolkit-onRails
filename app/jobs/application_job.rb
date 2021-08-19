class ApplicationJob < ActiveJob::Base
  def twi_client(tweet)
    Twitter::REST::Client.new config(tweet)
  end

  def twi_sclient(tweet)
    Twitter::Streaming::Client.new config(tweet)
  end

  def config(tweet)
    {
      consumer_key: tweet.key,
      consumer_secret: tweet.secret,
      access_token: tweet.token,
      access_token_secret: tweet.token_secret,
      proxy: proxy(tweet)
    }
  end

  def proxy(tweet)
    unless tweet.host.empty?
      {
        host: tweet.host,
        port: tweet.port,
        username: tweet.username,
        password: tweet.password
      }
    end
  end

  def follow(*args)
    array = get_user_lists(args[0])
    list = array[0] - array[1]
    save_follow_list(list, args[1])
    list
  end

  def unfollow(tweet)
    array = get_user_lists(tweet)
    array[1] - array[0]
  end

  def get_user_lists(tweet)
    [GetFollowersJob.perform_now(tweet), GetFriendsJob.perform_now(tweet)]
  end
end
