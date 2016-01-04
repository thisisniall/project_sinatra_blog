require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"

require "./models.rb"
set :database, "sqlite3:myblogdb.sqlite3"

enable :sessions