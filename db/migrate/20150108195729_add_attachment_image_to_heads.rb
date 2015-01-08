class AddAttachmentImageToHeads < ActiveRecord::Migration
  def self.up
    change_table :heads do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :heads, :image
  end
end
