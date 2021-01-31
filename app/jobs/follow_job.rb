class FollowJob < ApplicationJob
  TwitterFuck = Class.new(StandardError)

  retry_on TwitterFuck, wait: 3.minutes, attempts: 5
  queue_as :default

  def perform(tweet)
    config = {
      consumer_key: tweet&.key,
      consumer_secret: tweet&.secret,
      access_token: tweet&.token,
      access_token_secret: tweet&.token_secret
    }
    client = Twitter::REST::Client.new config

    followers = Twi.get_followers(client, config)
    followers_total = Twi.get_followers_total(followers)
    friends_total = Twi.get_friends(client, config)
    follow = followers_total - friends_total

    follow.take(100).reverse_each do |user|
      (client.follow(user)
       follow.delete(user)
       puts "follow: #{user.screen_name} #{Time.now}") ||
        raise(TwitterFuck)
    end
  end
end
