class Post < ActiveRecord::Base
	acts_as_votable
	belongs_to :user
	has_many :heads, :dependent => :destroy
	has_many :comments
	accepts_nested_attributes_for :heads, :allow_destroy => true 
end
