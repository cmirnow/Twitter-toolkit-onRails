class GetTweetsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    array = []
    CSV.open('twitts.csv', 'w') do |csv|
      client.search(args[1], result_type: 'recent', tweet_mode: 'extended').take(30).collect do |tweet|
        array << tweet
                 .attrs[:full_text]
                 .gsub(args[1], '')
                 .gsub('@:', '')
                 .gsub('@', '')
                 .gsub('RT :', '')
                 .gsub('RT', '')
      end
      array.map { |n| csv << [n] }
    end
    array
  end
end
