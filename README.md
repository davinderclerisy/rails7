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

Bundle Instal
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

