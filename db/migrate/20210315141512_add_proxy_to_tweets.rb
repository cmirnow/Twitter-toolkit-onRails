class AddProxyToTweets < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :host, :string
    add_column :tweets, :port, :integer
    add_column :tweets, :username, :string
    add_column :tweets, :password, :string
  end
end
