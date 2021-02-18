class UnfollowJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    list = unfollow(args[0])
    begin
      list.take(1000).each do |user|
        client.unfollow(user.id)
        list.delete(user)
        puts "unfollow: #{user.screen_name} #{Time.now}"
        sleep rand(1..5)
      end
    rescue Twitter::Error::TooManyRequests,
           Twitter::Error::Forbidden,
           OpenSSL::SSL::SSLError,
           Twitter::Error::ServiceUnavailable,
           HTTP::Error
      []
      puts "rescue Twitter::Error #{Time.now}"
      sleep 90
      retry
    end
  end
end
