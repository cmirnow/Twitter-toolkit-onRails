class RetweetsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[1])
    sclient = twi_sclient(args[1])

    counter = 0
    while counter <= 30
      begin
        sclient.filter(track: args[0].join(',')) do |tweet|
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
