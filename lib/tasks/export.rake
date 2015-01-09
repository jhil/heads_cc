namespace :export do
  desc "Prints User.all, Post.all, and Head.all in a seeds.rb way."
  task :seeds_format => :environment do
    Head.order(:id).all.each do |head|
      puts "Head.create(#{head.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    Post.order(:id).all.each do |post|
      puts "Post.create(#{post.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
    User.order(:id).all.each do |user|
      puts "User.create(#{user.serializable_hash.delete_if {|key, value| ['created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')})"
    end
  end
end