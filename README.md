## Ruby On Rails 7 REST API

# Setup

Install RVM
```
https://github.com/rvm/ubuntu_rvm
```

Install Ruby
```
sudo apt-get install ruby-full
```

Install Bundle
```
sudo gem install bundler
```

Bundle Install
```
bundle install
```

Setup enviroment file
rename .env.example to .env



Setup Database
```
bin/rails db:setup
```

Run Development Web Server
```
bin/rails server
```

Run Production Web Server
```
bin/rails server -e=production
```

Access Explorer
```
http://127.0.0.1:3000/explorer
```

