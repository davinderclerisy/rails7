# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Learn Ruby
https://youtu.be/t_ispmWmdjY?si=QYjui1QUH6iDXV59

Introduction
Hello World / Setup
Variables
Data Types
Working With Strings
Symbols
Math & Numbers
Getting User Input
Arrays
Hashes
Methods
Return Statement
If Statements
Case Expressions
While Loops
For Loops
Comments
Reading Files
Writing Files
Handling Errors
Classes & Objects
Initialize Method
Object Methods
Inheritance
Modules




// Install RVM
https://github.com/rvm/ubuntu_rvm

// Install Ruby
sudo apt-get install ruby-full

// Install sqlite3 (optional)
sudo apt install sqlite3

// Install Ruby on Rails
sudo gem install rails

// Install bundler
sudo gem install bundler

// Postgresql Client library
sudo apt install libpq-dev -y

// Create ROR api with postgresql skip test cases(-T)
rails new ror-api --api -d postgresql -T

// Update Database Creds
    config/database.yml

// Add dotenv
    In `Gemfile` file add following line after 'gem "rails"...'
gem 'dotenv-rails'
    Then run
bundle install

// To create database run (if not exist)
rake db:create


// Enable cors
    In file `config/initializers/cors.rb`
    uncomment 8-16 lines
    In `Gemfile` uncomment line gem "rack-cors"
    Then run
    bundle install

// Run Development Web Server
    cd ror-api
bin/rails server

// Create Swagger Doc
rails rswag:specs:swaggerize
or
rake rswag:specs:swaggerize

# Excute particular spec file
bundle exec rspec spec/integration/authentication_spec.rb

# Doc
https://guides.rubyonrails.org/api_app.html
https://guides.rubyonrails.org/getting_started.html
# Setup Rails
https://medium.com/@kelseythang/building-a-restful-crud-api-with-ruby-on-rails-c4ccd8f7f180

# Swagger
https://medium.com/@sushildamdhere/how-to-document-rest-apis-with-swagger-and-ruby-on-rails-ae4e13177f5d


=========================


rails new artist_project --api --minimal --database=postgresql


// Generate Resource
rails g resource Post title:string body:string user is_active:boolean

// Create Associations
rails g resource Post user:references title:string body:text

// Add New Columns
rails generate migration AddIsPublicAndIsDraftToPosts is_public:boolean is_draft:boolean

// Check version
rails about

// Rails + Devise + Devise Jwt
https://sdrmike.medium.com/rails-7-api-only-app-with-devise-and-jwt-for-authentication-1397211fb97c

=== Simple
https://www.bluebash.co/blog/rails-6-7-api-authentication-with-jwt/

===



https://medium.com/@sushildamdhere/how-to-document-rest-apis-with-swagger-and-ruby-on-rails-ae4e13177f5d
