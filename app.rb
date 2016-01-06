require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"

require "./models.rb"
set :database, "sqlite3:myblogdb.sqlite3"

enable :sessions

get '/' do
	if current_user
		@user = current_user
		erb :index
	else 
		redirect 'sign_in'
	end
end

post '/logout' do
	session.clear
	redirect '/sign_in'
end

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do
	@user = User.find_by(username: params[:username])
	# alt: @user = User.find_by_username params[:username]
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User #{@user.username} signed in successfully."
		redirect '/'
	else
		flash[:alert] = "Your username or password does not match our records, please try again."
		redirect 'sign_in'	
	end	
end

post '/sign_up' do
	if #form is filled out#
		@user = User.create(username: params[:username], password: params[:password], fname: params[:fname], lname: params[:lname], email: params[:email])
		session[:user_id] = @user.id
		flash[:notice] = "Thank you for joining BLOGNAME"
		redirect '/'
	else
		flash[:alert] = "Please fill out the entire form."
		redirect '/sign_in'
	end	
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
		# ternary operator version:
		# session[:user_id] ? @current_user = User.find(session[:user_id]) : nil
	end
end

post '/newpost' do
	@newpost = Post.create(user_id: session[:user_id], title: params[:title], content: params[:content])
	redirect '/'
end

get '/manage' do
	@user = current_user
	erb :manage
end

post '/manage' do
	@user = current_user
	@user.update(password: params[:password], fname: params[:fname], lname: params[:lname], email: params[:email])
	if @user.save
		redirect '/'
	else 
		redirect '/sign_in'
	end
end

post '/deleteaccount' do
	@user = current_user
	flash[:notice] = "Your account has been deleted."
	User.destroy(@user)
	session.clear
	redirect '/sign_in'
end

get '/users/:id' do
	@user_viewed = User.find(params[:id])
	# where necessary here - find_by would be the alternative but gives only the top result
	@posts_viewed = Post.where(params[:user_id])
	erb :user_individual
end