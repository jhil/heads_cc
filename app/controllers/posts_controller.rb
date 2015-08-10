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
		@post.heads.each { |head|
			large = head.image.url(:large)
			medium = head.image.url(:medium)
			small = head.image.url(:small)
			puts "#{large} #{medium} #{small}"
		}
		send_file file_path+".zip", filename: @post.get_slug+".zip", :disposition => 'attachment'
	end

	private

	def find_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:heads, :title, :link, :description)
	end

end
