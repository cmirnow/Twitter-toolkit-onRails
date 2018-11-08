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
			followers_total = Twi.get_followers(client, config)
			friends_total = Twi.get_friends(client, config)
		end
        
        case
		when params[:select_action] == 'follow'
			follow = followers_total - friends_total
			Twi.follow(client, follow)
		when params[:select_action] == 'unfollow'
			unfollow = friends_total - followers_total
			Twi.unfollow(client, unfollow)
		when params[:select_action] == 'retweet'
			topics = params['tag'].split(/,/)
			Twi.retweet(config, topics)
		when params[:select_action] == 'post'
			array_posts = params[:tag].split(/[\r\n]+/)
			Twi.post(config, array_posts)
        end

	end
end
