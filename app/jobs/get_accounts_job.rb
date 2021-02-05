class GetAccountsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    array = []
    CSV.open('followers.csv', 'w') do |csv|
      args[0].each_with_index do |user, index|
        print "\r#{index}/#{args[0].count} complete"
        csv << [user['screen_name']]
        array << user['screen_name']
      end
    end
    array
  end
end
