class GetFollowersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    config = args[1] || config(args[0])

    follower_ids = []
    next_cursor = -1
    begin
      while next_cursor != 0
        cursor = client.follower_ids(config, cursor: next_cursor)
        follower_ids.concat cursor.attrs[:ids]
        next_cursor = cursor.send(:next_cursor)
      end
    rescue Twitter::Error::Unauthorized,
           Twitter::Error::ServiceUnavailable,
           HTTP::Error
      []
      puts "rescue Twitter::Error #{Time.now}"
      retry
    end
    followers = []
    follower_ids.each_slice(100) do |ids|
      followers.concat client.users(ids)
    end
    followers_total = []
    followers.each do |user|
      followers_total << user.id
      puts "adding follower to an array: #{user.screen_name}"
    end
  end
end
