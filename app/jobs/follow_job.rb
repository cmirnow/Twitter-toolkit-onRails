class FollowJob < ApplicationJob
  queue_as :default

  def perform(tweet, follow)
    config = {
      consumer_key: tweet&.key,
      consumer_secret: tweet&.secret,
      access_token: tweet&.token,
      access_token_secret: tweet&.token_secret
    }
    client = Twitter::REST::Client.new config
    begin
      follow.take(100).reverse_each do |user|
        client.follow(user['id'])
        follow.delete(user)
        puts "follow: #{user['screen_name']} #{Time.now}"
        sleep rand(30..60)
      end
    end
  rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
    []
    puts "rescue Twitter::Error #{Time.now}"
    sleep 905
    retry
  end
end
