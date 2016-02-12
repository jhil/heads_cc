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

  def zip dir="#{Rails.root}/tmp", override=false
    zip_filename = "#{self.slug}.zip"
    tmp_filename = "#{dir}/#{zip_filename}"

    File.delete tmp_filename if override and File.exist? tmp_filename

    if not File.exist? tmp_filename
      Zip::File.open(tmp_filename, Zip::File::CREATE) do |zip|
        self.heads.each do |e|
          e.image.styles.each do |style_name, style|
            attachment = Paperclip.io_adapters.for(style)
            zip.add("#{style_name}/#{e.image.original_filename}", attachment.path)
          end
        end
      end
    end
    return tmp_filename
  end

  # zips the pack and overrides the existing zip folder
  def zip! dir="#{Rails.root}/tmp"
    self.zip dir, true
  end

end
