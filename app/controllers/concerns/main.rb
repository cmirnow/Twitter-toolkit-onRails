module Main
	extend ActiveSupport::Concern

	def index
		@tweets = current_user.tweet
		tweet = @tweets.detect {
			|t| params[:select] == t.name
		}

		config = {
			consumer_key: tweet&.key,
			consumer_secret: tweet&.secret,
			access_token: tweet&.token,
			access_token_secret: tweet&.token_secret
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
