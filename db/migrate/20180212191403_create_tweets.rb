class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.string :name
      t.string :key
      t.string :secret
      t.string :token
      t.string :token_secret
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
