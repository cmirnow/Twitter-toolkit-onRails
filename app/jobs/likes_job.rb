class LikesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[1])
    sclient = twi_sclient(args[1])

    counter = 0
    sclient.filter(track: args[0].join(',')) do |tweet|
      puts tweet.text
      puts client.fav tweet
      counter += 1
      # You can determine the number of likes here:
      break if counter == 10

      sleep rand(10..25)
    end
  end
end
