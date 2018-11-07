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
		begin
			followers_total = []
			followers.each_with_index do |user, _index|
				followers_total << user.id
				puts "adding follower to an array: #{user.id}"
			end
		rescue Twitter::Error::TooManyRequests
			[]
			puts "rescue Twitter::Error #{Time.now}"
			sleep 905
			retry
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
		begin
			friends_total = []
			#friends = get_friends(client)
			friends.each_with_index do |user, _index|
				friends_total << user.id
				puts "adding friend to an array: #{user.id}"
			end
		rescue Twitter::Error::TooManyRequests
			[]
			puts "rescue Twitter::Error #{Time.now}"
			sleep 905
			retry
		end
	end
	
    def self.follow(client, follow)
		begin
			follow.take(100).reverse_each do |user, _index|
				client.follow(user.id)
				follow.delete(user.id)
				puts "follow: #{user.id} #{Time.now}"
				sleep rand(1..5)
			end
		rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
			[]
			puts "rescue Twitter::Error #{Time.now}"
			sleep 905
			retry
		end
	end
    
	def self.unfollow(client, unfollow)
		begin
			unfollow.take(1000).reverse_each do |user, _index|
				client.unfollow(user.id)
				unfollow.delete(user.id)
				puts "unfollow: #{user.id} #{Time.now}"
				sleep rand(1..5)
			end
		rescue Twitter::Error::TooManyRequests, Twitter::Error::Forbidden, OpenSSL::SSL::SSLError, Twitter::Error::ServiceUnavailable, HTTP::ConnectionError
			[]
			puts "rescue Twitter::Error #{Time.now}"
			sleep 905
			retry
		end
	end

	def self.retweet(config, topics)    
		$i = 0
		$num = 15
		$i1 = 0
		while $i + $i1 <= $num
			begin
				rClient = Twitter::REST::Client.new config
				sClient = Twitter::Streaming::Client.new(config)
				sClient.filter(track: topics.join(',')) do |tweet|
					if tweet.is_a?(Twitter::Tweet)
						puts tweet.text
						rClient.retweet tweet
						$i += 1
						sleep rand(1..15)
						break if $i1 == 15
					end
				end
			rescue StandardError
				puts 'error occurred, waiting for 5 seconds'
				$i1 += 1
				sleep 5
				break if $i1 == 15
			end
		end
	end

	def self.post(config, array_posts)
		client = Twitter::REST::Client.new config
		array_posts.each do |i|
			client.update(i)
			sleep rand(1..10)
		end
	end

end
