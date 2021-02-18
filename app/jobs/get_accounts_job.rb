class GetAccountsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    array = []
    list = GetFollowersJob.perform_now(*args)
    CSV.open('followers.csv', 'w') do |csv|
      list.each_with_index do |user, index|
        print "\r#{index}/#{list.count} complete."
        csv << [user.screen_name]
        array << user.screen_name
      end
    end
    array
  end
end
