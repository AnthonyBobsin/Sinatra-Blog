require "sinatra"
require "sinatra/activerecord"
require './environments.rb'

class Post < ActiveRecord::Base
	validate :title, presence: true, length: { minimum: 3 }
	validate :body, presence: true
	validate :author, presence: true
	validate :img, presence: true
end

# Get the homepage
get "/" do
	@posts = Post.order("created_at DESC")
	erb :"posts/index"
end

# Get the new post form
get "/posts/new" do
	@title = "New Post"
	@post = Post.new
	erb :"posts/new"
end

# Creates a new post with the params given
# If successful redirect to that post
# else get new post form
post "/posts" do
	@post = Post.new(params[:post])
	if @post.save
		redirect "posts/#{@post.id}"
	else
		erb :"posts/new"
	end
end

# Get the post with this specific id
get "/posts/:id" do
	@post = Post.find(params[:id])
	@title = @post.title
	erb :"posts/show"
end

# Get the edit form
get "/posts/:id/edit" do
	@post = Post.find(params[:id])
	@title = "Edit Form"
	erb :"posts/edit"
end

# Modifies the post with the given id
# If successful redirect to that post
# else get the edit post form
put "/posts/:id" do
	@post = Post.find(params[:id])
	if @post.update_attributes(params[:post])
		redirect "/posts/#{@post.id}"
	else
		erb :"posts/edit"
	end
end

# Deletes the post with the given id
# Then redirects to homepage
delete "/posts/:id" do
	@post = Post.find(params[:id]).destroy
	redirect "/"
end

# Get the about page
get "/about" do
	erb :"about"
end


helpers do

	def title
		if @title 
			"#{@title} -- My Blog"
		else
			"My Blog"
		end
	end

	def pretty_date(time)
		time.strftime("%d %m %Y")
	end

	def about_page?
		request.path_info == '/about'
	end

	def post_show_page?
		request.path_info =~ /\/posts\/\d+$/
	end

	def delete_post_button(post_id)
    	erb :_delete_post_button, locals: { post_id: post_id}
  	end

end