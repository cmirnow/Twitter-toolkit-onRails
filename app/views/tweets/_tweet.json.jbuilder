json.extract! tweet, :id, :name, :key, :secret, :token, :token_secret, :user_id, :created_at, :updated_at
json.url tweet_url(tweet, format: :json)
