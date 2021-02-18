class FollowJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    list = follow(args[0])
    begin
      list.take(100).reverse_each do |user|
        client.follow(user.id)
        list.delete(user)
        puts "follow: #{user.screen_name} #{Time.now}"
        sleep rand(30..60)
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
