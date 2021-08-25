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

  def save_follow_list(*args)
    CSV.open(path_to_csv_file(args[1]), 'w') do |csv|
      csv << args[0].map { |e| e.screen_name }
    end
  end

  def dynamic_follow_list(nick)
    array_of_ids = CSV.open(path_to_csv_file(nick)).to_a.flatten.drop(1)
    CSV.open(path_to_csv_file(nick), 'w') do |csv|
      csv << array_of_ids
    end
  end

  def path_to_csv_file(nick)
    "#{Rails.root}/follow_lists/" + nick + '.csv'
  end
end
