class Post < ActiveRecord::Base
	belongs_to :user
	has_many :heads, :dependent => :destroy
	has_many :comments
	accepts_nested_attributes_for :heads, :allow_destroy => true 

	def create_zip
		slug = self.get_slug
		`cd "#{$uploads_path}" && zip -r "#{slug}" "#{slug}"`
	end

	def get_file_path
		return $uploads_path+"/#{self.get_slug}"
	end

	def get_slug
		return self.title.parameterize
	end
end
