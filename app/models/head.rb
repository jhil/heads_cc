class Head < ActiveRecord::Base
	belongs_to :post

	has_attached_file :image,
		:dependent => :destroy, # if a post is destroyed, the associated heads will destroy also
		:path => ":rails_root/public/uploads/:post_id/:style/:filename",
		:url  => "/uploads/:post_id/:style/:filename",
		:styles => {
		  :large => "100x100>",
		  :medium  => "72x72>",
		  :small => "32x32>"
		}
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	Paperclip.interpolates :post_id do |attachment, style|
		attachment.instance.post_id
	end

	def post_id
		return self.post.id
	end

  # directory containing all heads for the post (relative to path)
  def root_directory
    return File.expand_path('../..', self.image.path)
  end

	# after_save :destroy_original

	private
	
	def destroy_original # remove originals
		File.unlink(self.image.path) # remove original files
		FileUtils.rmdir(File.expand_path("..", self.image.path)) # remove original folder
	end

end
