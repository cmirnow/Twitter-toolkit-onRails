class UnfollowJob < ApplicationJob
  TwitterFuck = Class.new(StandardError)

  retry_on TwitterFuck, wait: 3.minutes, attempts: 5
  queue_as :default

  def perform(*args)
    config = {
      consumer_key: args[1]&.key,
      consumer_secret: args[1]&.secret,
      access_token: args[1]&.token,
      access_token_secret: args[1]&.token_secret
    }
    client = Twitter::REST::Client.new config

    args[0].take(1000).reverse_each do |user|
      client.unfollow(user["id"])
      args[0].delete(user["id"])
      puts "unfollow: #{user["screen_name"]} #{Time.now}"
      sleep rand(1..5)
    end
  rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
    []
    puts "rescue Twitter::Error #{Time.now}"
    sleep 905
    retry
  end
end
