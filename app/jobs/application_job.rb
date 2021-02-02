class ApplicationJob < ActiveJob::Base
  def twi_client(tweet)
    Twitter::REST::Client.new config(tweet)
  end

  def twi_sclient(tweet)
    Twitter::Streaming::Client.new config(tweet)
  end

  def config(tweet)
    {
      consumer_key: tweet&.key,
      consumer_secret: tweet&.secret,
      access_token: tweet&.token,
      access_token_secret: tweet&.token_secret
    }
  end
end
