class UseListToFollowJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    list = follow_list(args[1])
    begin
      list.take(100).each do |user|
        client.follow(user)
        list.delete(user)
        dynamic_follow_list(args[1])
        puts "follow: #{user} #{Time.now}"
        sleep rand(30..60)
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

  def follow_list(nick)
    CSV.open(path_to_csv_file(nick)).to_a.flatten
  end
end
