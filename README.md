# Ruby On Rails 7 API

## Prerequisites
Ruby 3.0.2

Redis 6

Postgresql

## Setup

Install RVM
```
https://github.com/rvm/ubuntu_rvm
```

Install Ruby
```
sudo apt-get install ruby-full
```

Install Ruby Gem (if not exist)
```
sudo apt install rubygems -y
```

Install Bundle
```
sudo gem install bundler
```

Bundle Install
```
bundle install
```

### Setup enviroment file

Rename .env.example to .env


Setup Database
```
bin/rails db:create
```
```
bin/rails db:migrate
```


## Run
Run Development Web Server
```
bin/rails server
```

Run Production Web Server
```
bin/rails server -e=production
```

Access OAS (Swagger)
```
http://127.0.0.1:3000/explorer
```
Run Queue Worker (Sidekiq)
```
bin/rails sidekiq
```

## Migration

### Create Migration
```
rails generate migration AddIsVerifiedToUsers is_verified:boolean
```

### Run Migration
```
bin/rails db:migrate
```

## Test

### Run
```
bundle exec rspec spec

```

### Generate Open Api Specification (Swagger)
```
bin/rails rswag:specs:swaggerize
```
