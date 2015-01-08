class AddAttachmentHeadToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :head
    end
  end

  def self.down
    remove_attachment :posts, :head
  end
end
