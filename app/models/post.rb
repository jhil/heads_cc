class Post < ActiveRecord::Base
	belongs_to :user
	has_many :heads, :dependent => :destroy
	has_many :comments
	accepts_nested_attributes_for :heads, :allow_destroy => true 

	def get_file_path
		return $uploads_path+"/#{self.get_slug}"
	end

	def get_slug
		return self.title.parameterize
	end
end
