Paperclip.interpolates :post_title do |attachment, style|
  attachment.instance.post.title
end
