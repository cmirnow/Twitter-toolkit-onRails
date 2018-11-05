
Twitter toolkit onRails can Follow, Unfollow, Retweet and Posts.

Would you like to take a look at the video?

Thank you, thank you very much. I already hear your admiring exclamations.

But!

Guys, don't forget please. This is a concept only. I am working on improving and refactoring this rails-app.
[Description](https://masterpro.ws/ruby-on-rails-twitter-tools) (in Russian).


[![Twitter toolkit onRails](https://img.youtube.com/vi/0nKzoxSbt1c/0.jpg)](https://www.youtube.com/watch?v=0nKzoxSbt1c "Twitter toolkit onRails")

## Running Locally
* Make sure you have Ruby and Postgresql installed.
```bash
sudo service postgresql start
sudo -u postgres psql
postgres=# CREATE DATABASE development_test2;
git clone https://github.com/cmirnow/Twitter-toolkit-onRails.git
cd Twitter-toolkit-onRails
bundle
bin/rails db:migrate RAILS_ENV=development
rails s
```
* Go to http://localhost:3000
* Sign up
* Sign in
* Create New Tweet now. Attention, you need to get four keys of Twitter API: Consumer Key, Consumer Secret, Access Token and Access Token Secret.
* Select one of four actions (follow, unfollow, retweet, post).
* Go ahead. :)
