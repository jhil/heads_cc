class Post < ActiveRecord::Base
	acts_as_votable
	belongs_to :user
	has_many :heads, :dependent => :destroy
	has_many :comments
	accepts_nested_attributes_for :heads, :allow_destroy => true 
	# has_attached_file :image, styles: { large: "100x100>", medium: "72x72>", small: "32x32>" }
	# validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
