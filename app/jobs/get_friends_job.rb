class GetFriendsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = twi_client(args[0])
    config = config(args[0])

    friend_ids = []
    next_cursor = -1
    begin
      while next_cursor != 0
        cursor = client.friend_ids(config, cursor: next_cursor)
        friend_ids.concat cursor.attrs[:ids]
        next_cursor = cursor.send(:next_cursor)
      end
    rescue Twitter::Error::Unauthorized,
           Twitter::Error::ServiceUnavailable,
           HTTP::Error
      []
      puts "rescue Twitter::Error #{Time.now}"
      retry
    end
    friends = []
    friend_ids.each_slice(100) do |ids|
      friends.concat client.users(ids)
    end
    friends.map { |user| puts "adding friend to an array: #{user.screen_name}" }
    friends
  end
end
