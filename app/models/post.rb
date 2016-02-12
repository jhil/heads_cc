class Post < ActiveRecord::Base
	belongs_to :user
	has_many :heads, :dependent => :destroy
	has_many :comments
	accepts_nested_attributes_for :heads, :allow_destroy => true 
  custom_slugs_with :title

	def get_pack_path
		return $uploads_path+"/#{self.id}"
	end

	def slug
		return self.title.parameterize
	end

  def zip override=false
    head = self.heads.first
    return if head == nil # no attachments to zip

    dir = head.root_directory
    rel_zip_name = "../#{self.slug}.zip"
    abs_zip_path = File.expand_path(rel_zip_name, dir)

    File.delete abs_zip_path if override

    if not File.exist? abs_zip_path
      cmd = "cd \"#{dir}\" && zip -r \"#{rel_zip_name}\" ."
      exec cmd
    end

    Pathname.new(abs_zip_path)
  end

  # zips the pack and overrides the existing zip folder
  def zip!
    self.zip true
  end

end
