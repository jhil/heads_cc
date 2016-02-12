require 'open-uri'
require 'zip'
class PostsController < ApplicationController

	before_action :find_post, only: [:show, :edit, :update, :destroy, :download, :embed]
	before_action :authenticate_user!, only: [:edit, :update, :destory]

	def index
		@posts = Post.all.order("title ASC")
	end

	def show
		@comments = Comment.where(post_id: @post)
		@heads = Head.where(post_id: @post)
		@random_post = Post.where.not(id: @post).order("RANDOM()").first
	end

	def new
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)

		if @post.save

			if params[:images]
			  params[:images].each { |image|
			    @post.heads.create(image: image)
			  }
			end

			redirect_to @post
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end

	def download
    zip = @post.zip
		send_file zip, :type => 'application/zip', :filename => "#{@post.get_slug}.zip", :disposition => 'attachment'
	end

	def embed
		image = @post.heads.sample.image
		params[:size] = :large unless params[:size] != nil
		send_file image.path(params[:size]), :type => image.content_type, disposition: "inline"
	end

	private

	def find_post
		@post = Post.find(params[:id])
		redirect_to_good_slug(@post) and return if bad_slug?(@post)
	end

	def post_params
		params.require(:post).permit(:heads, :title, :link, :description)
	end

end
