class Head < ActiveRecord::Base
	belongs_to :post
	has_attached_file :image,
		:path => ":rails_root/public/images/:id/:filename",
		:url  => "/images/:id/:filename",
		styles: { large: "100x100>", medium: "72x72>", small: "32x32>" }
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
