class Head < ActiveRecord::Base
	belongs_to :post

	has_attached_file :image,
		:dependent => :destroy, # if a post is destroyed, the associated heads will destroy also
		:path => ":rails_root/public/uploads/:post_title/:style/:filename",
		:url  => "/uploads/:post_title/:style/:filename",
		:styles => {
		  :large => "100x100>",
		  :medium  => "72x72>",
		  :small => "32x32>" }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	after_save :destroy_original
	after_save :create_zip

	def self.create_zip post
		post_slug = post.title.parameterize
		uploads_path = "#{Rails.root}/public/uploads"
		file_path = uploads_path+"/#{post_slug}"

		`cd "#{uploads_path}" && zip -r "#{post_slug}" "#{post_slug}"`
	end

	private
	
	def destroy_original # remove originals
		File.unlink(self.image.path) # remove original files
		FileUtils.rmdir(File.expand_path("..", self.image.path)) # remove original folder
	end

	def create_zip
		Head.create_zip Post.find(self.post_id)
	end
end
