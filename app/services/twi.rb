class Twi
    
	def self.get_followers(client, user_id)
		follower_ids = []
		next_cursor = -1
		while next_cursor != 0
			cursor = client.follower_ids(user_id, :cursor => next_cursor)
			follower_ids.concat cursor.attrs[:ids]
			next_cursor = cursor.send(:next_cursor)
		end
		followers = []
		follower_ids.each_slice(100) do |ids|
			followers.concat client.users(ids)
		end
        followers
    end
    
    def self.get_followers_total followers
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
				cursor = client.friend_ids(user_id, :cursor => next_cursor)
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
    
    def self.follow(client, follow)
		counter = 0
		begin
			follow.take(100).reverse_each do |user| if counter <= 2
				client.follow(user)
				follow.delete(user)
				puts "follow: #{user.screen_name} #{Time.now}"
				sleep rand(1..5)
			end
		end
	rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
		[]
		puts "rescue Twitter::Error #{Time.now}"
		counter += 1
		sleep 905
		retry
	end
    end
    
    def self.unfollow(client, unfollow)
	begin
		unfollow.take(1000).reverse_each do |user|
			client.unfollow(user)
			unfollow.delete(user)
			puts "unfollow: #{user.screen_name} #{Time.now}"
			sleep rand(1..5)
		end
	rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
		[]
		puts "rescue Twitter::Error #{Time.now}"
		sleep 905
		retry
	end
    end
    
    def self.retweet(client, sclient, topics)    
	counter = 0
	while counter <= 15
		begin
			sclient.filter(track: topics.join(',')) do |tweet|
				if tweet.is_a?(Twitter::Tweet)
					puts tweet.text
					client.retweet tweet
					counter += 1
					sleep rand(1..15)
				end
			end
		rescue StandardError
			puts 'error occurred, waiting for 5 seconds'
			counter += 1
			sleep 5
		end
	end
    end
    
    def self.post(client, array_posts)
	array_posts.each do |i|
		puts client.update(i)
		sleep rand(1..10)
	end
    end
    
    def self.parser(client, twi_acc)
	arr = Set.new
	CSV.open("twitts.csv", "w") do |csv|
		client.search(twi_acc, result_type: "recent", tweet_mode: "extended").take(30).collect do |tweet|
			arr << tweet
                .attrs[:full_text]
                .gsub(twi_acc, "")
                .gsub("RT :", "")
                .gsub("RT", "")
		end
		arr.each do |item|
			csv << [item]
            puts item
		end
	end
    end
    
    def self.print_followers followers
		CSV.open("followers.csv", "w") do |csv|
			total = followers.count
			followers.each_with_index do |user, index|
				print "\r#{index}/#{total} complete"
				csv << [user.screen_name]
			end
		end
    end

end
