module Main
	extend ActiveSupport::Concern

		def index
		@tweets = current_user.tweet

		@tweets.each do |tweets|
			next unless params[:select] == tweets.name
			@a = tweets.key
			@b = tweets.secret
			@c =     tweets.token
			@d = tweets.token_secret
		end

		config = {
			consumer_key: @a,
			consumer_secret: @b,
			access_token: @c,
			access_token_secret: @d
		}

		if (params[:select_action] == 'follow') || (params[:select_action] == 'unfollow')
			client = Twitter::REST::Client.new config

			def get_follower_ids(client, user_id)
				follower_ids = []
				next_cursor = -1
				while next_cursor != 0
					cursor = client.follower_ids(user_id, cursor: next_cursor)
					follower_ids.concat cursor.attrs[:ids]
					next_cursor = cursor.send(:next_cursor)
				end
				follower_ids
			end

			def get_friend_ids(client, user_id)
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
				friend_ids
			end

			def get_followers_info(client)
				followers = []
				get_follower_ids(client, client.user.id).each_slice(100) do |ids|
					followers.concat client.users(ids)
				end
				followers
			end

			def get_friends_info(client)
				friends = []
				get_friend_ids(client, client.user.id).each_slice(100) do |ids|
					friends.concat client.users(ids)
				end
				friends
			end
			begin
				followers_total = []
				followers = get_followers_info(client)
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
			begin
				friends_total = []
				friends = get_friends_info(client)
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
				if params[:select_action] == 'follow'
			follow = followers_total - friends_total
			Twi.follow(client, follow)
		end

		if params[:select_action] == 'unfollow'
			unfollow = friends_total - followers_total
			Twi.unfollow(client, unfollow)
		end
				if params[:select_action] == 'retweet'
			topics = params['tag'].split(/,/)
			Twi.retweet(config, topics)
		end

		if params[:select_action] == 'post'
			array_posts = params[:tag].split(/[\r\n]+/)
			Twi.post(config, array_posts)
		end

	end
end

