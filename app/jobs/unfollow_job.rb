class UnfollowJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[1])

    args[0].take(1000).reverse_each do |user|
      client.unfollow(user['id'])
      args[0].delete(user['id'])
      puts "unfollow: #{user['screen_name']} #{Time.now}"
      sleep rand(1..5)
    end
  rescue Twitter::Error::TooManyRequests,
         Twitter::Error::Forbidden,
         OpenSSL::SSL::SSLError,
         Twitter::Error::ServiceUnavailable,
         HTTP::Error
    []
    puts "rescue Twitter::Error #{Time.now}"
    sleep 905
    retry
  end
end
