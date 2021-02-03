class Twi
  def self.get_followers(*args)
    follower_ids = []
    next_cursor = -1
    while next_cursor != 0
      cursor = args[0].follower_ids(args[1], cursor: next_cursor)
      follower_ids.concat cursor.attrs[:ids]
      next_cursor = cursor.send(:next_cursor)
    end
    followers = []
    follower_ids.each_slice(100) do |ids|
      followers.concat args[0].users(ids)
    end
    followers
  end

  def self.get_followers_total(followers)
    followers_total = []
    followers.each_with_index do |user, _index|
      followers_total << user.id
      puts "adding follower to an array: #{user.screen_name}"
    end
  end

  def self.get_friends(*args)
    friend_ids = []
    next_cursor = -1
    begin
      while next_cursor != 0
        cursor = args[0].friend_ids(args[1], cursor: next_cursor)
        friend_ids.concat cursor.attrs[:ids]
        next_cursor = cursor.send(:next_cursor)
      end
    rescue Twitter::Error::Unauthorized
      []
    end
    friends = []
    friend_ids.each_slice(100) do |ids|
      friends.concat args[0].users(ids)
    end
    friends_total = []
    friends.each_with_index do |user, _index|
      friends_total << user.id
      puts "adding friend to an array: #{user.screen_name}"
    end
  end

  def self.parser(*args)
    array = []
    CSV.open('twitts.csv', 'w') do |csv|
      args[0].search(args[1], result_type: 'recent', tweet_mode: 'extended').take(30).collect do |tweet|
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

  def self.print_followers(followers)
    array = []
    CSV.open('followers.csv', 'w') do |csv|
      followers.each_with_index do |user, index|
        print "\r#{index}/#{followers.count} complete"
        csv << [user.screen_name]
        array << user.screen_name
      end
    end
    array
  end
end
