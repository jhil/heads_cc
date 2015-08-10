require 'open-uri'
require 'zip'
class PostsController < ApplicationController

	before_action :find_post, only: [:show, :edit, :update, :destroy, :download]
	before_action :authenticate_user!, except: [:index, :show]

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
		heads = []
		@post.heads.each { |head|
			heads.push(head.image.url(:large))
			heads.push(head.image.url(:medium))
			heads.push(head.image.url(:small))
		}

		zip_str = begin
		Zip::OutputStream.write_buffer do |stream|
	    heads.each do |url|
	    	puts url
	      name = getName(url)
	      stream.put_next_entry(name)
	      download = open(url)
	      stream.print(download.read)
	      end
	    end
		end

		send_file zip_str, :type => 'application/zip', :filename => URI::encode(@post.title)+".zip", :disposition => 'attachment'
	end

	private

	def find_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:heads, :title, :link, :description)
	end

	def getName(url)
		return url.split("http://headscc.s3.amazonaws.com/app/public/uploads/")[1].split("?")[0]
	end

end
