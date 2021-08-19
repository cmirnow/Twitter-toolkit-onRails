class FollowJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    list = follow(*args)
    begin
      list.take(100).each do |user|
        client.follow(user.id)
        list.delete(user)
        dynamic_follow_list(args[1])
        puts "follow: #{user.screen_name} #{Time.now}"
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

  def dynamic_follow_list(nick)
    array_of_ids = CSV.open(path_to_csv_file(nick)).to_a.flatten.drop(1)
    CSV.open(path_to_csv_file(nick), 'w') do |csv|
      csv << array_of_ids
    end
  end

  def save_follow_list(*args)
    CSV.open(path_to_csv_file(args[1]), 'w') do |csv|
      csv << args[0].map { |e| e.id }
    end
  end

  def path_to_csv_file(nick)
    "#{Rails.root}/follow_lists/" + nick + '.csv'
  end
end
