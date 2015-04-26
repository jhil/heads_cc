class AddHeadImages < ActiveRecord::Migration
  def self.up
    add_attachment :posts, :head
  end

  def self.down
    remove_attachment :posts, :head
  end
end
