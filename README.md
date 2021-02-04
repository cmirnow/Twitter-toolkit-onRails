## Short description
Twitter Toolkit onRails can Follow, Unfollow, Retweet, Posts and Tweet Parser.

Would you like to take a look at the video?

Thank you, thank you very much. I already hear your admiring exclamations.

But!

Guys, don't forget please. This is a concept only. I am working on improving and refactoring this rails-app.

[Description](https://masterpro.ws/serializing-twitter-user-object-for-activejob) (in Russian).


[![Twitter Toolkit on Rails](https://github.com/cmirnow/Twitter-toolkit-onRails/blob/master/images/twitter-toolkit-on-rails-1.jpg)](https://masterpro.ws/serializing-twitter-user-object-for-activejob)


[![Twitter Toolkit on Rails](https://github.com/cmirnow/Twitter-toolkit-onRails/blob/master/images/twitter-toolkit-on-rails.jpg)](https://masterpro.ws/serializing-twitter-user-object-for-activejob)


## Running Locally
* Make sure you have Ruby and Postgresql installed.
```bash
git clone https://github.com/cmirnow/Twitter-toolkit-onRails.git
```
* Create .env file on the root of the project:
```bash
export GMAIL_USER_NAME = '***************'
export GMAIL_PASSWORD = '***************' 
```

```bash
sudo service postgresql start
sudo -u postgres psql
postgres=# CREATE DATABASE development_twi_toolkit;
cd Twitter-toolkit-onRails
bundle install
bin/rails db:migrate RAILS_ENV=development
rails s
```
* Go to http://localhost:3000.
* Sign up.
* Confirm your email.
* Sign in.
* Create New Tweet now. Attention, you need to get four keys of Twitter API: Consumer Key, Consumer Secret, Access Token and Access Token Secret.
* Select one of four actions (follow, unfollow, retweet, post).
* Go ahead. :)
