class Twi
  def self.get_followers(client, user_id)
    follower_ids = []
    next_cursor = -1
    while next_cursor != 0
      cursor = client.follower_ids(user_id, cursor: next_cursor)
      follower_ids.concat cursor.attrs[:ids]
      next_cursor = cursor.send(:next_cursor)
    end
    followers = []
    follower_ids.each_slice(100) do |ids|
      followers.concat client.users(ids)
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

  def self.get_friends(client, user_id)
    friend_ids = []
    next_cursor = -1
    begin
      while next_cursor != 0
        cursor = client.friend_ids(user_id, cursor: next_cursor)
        friend_ids.concat cursor.attrs[:ids]
        next_cursor = cursor.send(:next_cursor)
      end
    rescue Twitter::Error::Unauthorized
      []
    end
    friends = []
    friend_ids.each_slice(100) do |ids|
      friends.concat client.users(ids)
    end
    friends_total = []
    friends.each_with_index do |user, _index|
      friends_total << user.id
      puts "adding friend to an array: #{user.screen_name}"
    end
  end

  def self.parser(client, twi_acc)
    array = Set.new
    array1 = []
    CSV.open('twitts.csv', 'w') do |csv|
      client.search(twi_acc, result_type: 'recent', tweet_mode: 'extended').take(30).collect do |tweet|
        array << tweet
                 .attrs[:full_text]
                 .gsub(twi_acc, '')
                 .gsub('RT :', '')
                 .gsub('RT', '')
      end
      array.each do |item|
        csv << [item]
        array1 << item
        puts item
      end
    end
    array1
  end

  def self.print_followers(followers)
    array = []
    CSV.open('followers.csv', 'w') do |csv|
      total = followers.count
      followers.each_with_index do |user, index|
        print "\r#{index}/#{total} complete"
        csv << [user.screen_name]
        array << user.screen_name
      end
    end
    array
  end
end
