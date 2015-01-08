class Head < ActiveRecord::Base
	belongs_to :post

	has_attached_file :image,
		:dependent => :destroy,
		:path => ":rails_root/public/uploads/:post_title/:filename",
		:url  => "/uploads/:post_title/:filename",
		styles: { large: "100x100>", medium: "72x72>", small: "32x32>" }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
