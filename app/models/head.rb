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

	has_attached_file :zip

	# after_save :destroy_original
	after_save :create_zip

	private
	
	def destroy_original # remove originals
		File.unlink(self.image.path) # remove original files
		FileUtils.rmdir(File.expand_path("..", self.image.path)) # remove original folder
	end

	def create_zip
		Post.find(self.post_id).create_zip
	end

end
