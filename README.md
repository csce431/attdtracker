# Attendance Tracker

A barebones Rails app, which can easily be deployed to Heroku. See Attendance in  [Attendance Tracker](https://numberzz.herokuapp.com/) action!

## Running Locally

### Using Rails command

Make sure you have Ruby on Rails installed.

```sh
$ git clone https://github.com/csce431/attdtracker.git
$ cd attdtracker
$ bundle install
$ rails db:migrate
$ rails server -b 0.0.0.0
```

The app should now be running on [localhost:3000](http://localhost:3000/).

### Using Heroku

Make sure you have Ruby installed.  Also, install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) (formerly known as the Heroku Toolbelt).

```sh
$ git clone https://github.com/csce431/attdtracker.git
$ cd attdtracker
$ bundle install
$ bundle exec rake db:create db:migrate
$ heroku local
```

The app should now be running on [localhost:5000](http://localhost:5000/).

## Documentation

For more information about using Ruby on Heroku, see these Dev Center articles:

- [Ruby on Heroku](https://devcenter.heroku.com/categories/ruby)
