class Twi
		def self.follow(client, follow)
		begin
			follow.take(100).reverse_each do |line|
				client.follow(line)
				follow.delete(line)
				puts "follow: #{line} #{Time.now}"
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
			unfollow.take(1000).reverse_each do |line|
				client.unfollow(line)
				unfollow.delete(line)
				puts "unfollow: #{line} #{Time.now}"
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
