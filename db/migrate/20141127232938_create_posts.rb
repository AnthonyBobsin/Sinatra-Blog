class CreatePosts < ActiveRecord::Migration
  def up 
  	create_table :posts do |post|
  		post.string :title
        post.string :author
        post.string :img
  		post.text :body
  		post.timestamps
  	end
  end

  def down
  	drop_table :posts
  end
end