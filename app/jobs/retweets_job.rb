class RetweetsJob < ApplicationJob
  queue_as :default

  def perform(topics, tweet)
    config = {
      consumer_key: tweet&.key,
      consumer_secret: tweet&.secret,
      access_token: tweet&.token,
      access_token_secret: tweet&.token_secret
    }
    client = Twitter::REST::Client.new config
    sclient = Twitter::Streaming::Client.new config

    counter = 0
    while counter <= 30
      begin
        sclient.filter(track: topics.join(',')) do |tweet|
          if tweet.is_a?(Twitter::Tweet)
            puts tweet.text
            client.retweet tweet
            counter += 1
            sleep rand(10..45)
          end
        end
      rescue StandardError
        puts 'error occurred, waiting for 5 seconds'
        counter += 1
        sleep 15
      end
    end
  end
end
