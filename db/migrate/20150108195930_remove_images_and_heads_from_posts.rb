class RemoveImagesAndHeadsFromPosts < ActiveRecord::Migration
  def change
  	remove_attachment :posts, :head
    remove_attachment :posts, :image
  end
end
