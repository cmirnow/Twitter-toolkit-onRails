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
        client = Twitter::REST::Client.new config
        
		if (params[:select_action] == 'follow') || (params[:select_action] == 'unfollow')
			followers = Twi.get_followers(client, config)
            followers_total = Twi.get_followers_total(followers)
			friends_total = Twi.get_friends(client, config)
        elsif
            params[:select_action] == 'acc-parsering'
            user_id = params['tag']
			followers = Twi.get_followers(client, user_id)
        elsif params[:select_action] == 'retweeting'
            sclient = Twitter::Streaming::Client.new(config)
        end

		case
		when params[:select_action] == 'follow'
			follow = followers_total - friends_total
			Twi.follow(client, follow)
            flash[:notice] = 'Success'
		when params[:select_action] == 'unfollow'
			unfollow = friends_total - followers_total
			Twi.unfollow(client, unfollow)
            flash[:notice] = 'Success'
		when params[:select_action] == 'retweeting'
			topics = params['tag'].split(/,/)
			Twi.retweet(client, sclient, topics)
            flash[:notice] = 'Success'
		when params[:select_action] == 'posting'
			array_posts = params[:tag].split(/[\r\n]+/)
			Twi.post(client, array_posts)
            flash[:notice] = 'Success'
        when params[:select_action] == 'parsering'
            twi_acc = params['tag']
            twits_array = render :json => (Twi.parser(client, twi_acc)).join(', ')
            flash[:notice] = twits_array
        when params[:select_action] == 'acc-parsering'
            twi_array = render :json => (Twi.print_followers(followers)).join(', ')
            flash[:notice] = twi_array
            
        end

	end
end
