class FindAccountsToFollowJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[1])
    list = []

    client.search(args[0].join(','), result_type: 'recent').take(10).collect do |tweet|
      list << tweet.user
      puts "#{tweet.user.screen_name}: #{tweet.text}"
    end
    save_follow_list(list, args[2])
  end
end
