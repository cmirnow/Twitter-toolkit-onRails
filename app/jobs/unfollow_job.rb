class UnfollowJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    list = unfollow(args[0])
    begin
      list.take(1000).reverse_each do |user|
        client.unfollow(user.id)
        list.delete(user)
        puts "unfollow: #{user.screen_name} #{Time.now}"
        sleep rand(1..5)
      end
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
