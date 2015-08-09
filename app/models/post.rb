require 'zip'

class Post < ActiveRecord::Base
	belongs_to :user
	has_many :heads, :dependent => :destroy
	has_many :comments
	accepts_nested_attributes_for :heads, :allow_destroy => true 

	def create_zip
		slug = self.get_slug

		compressed_filestream = Zip::ZipOutputStream.write_buffer do |zos|
		  some_file_list.each do |file|
		    zos.put_next_entry(file.slug)
		    zos.print IO.read(file.path)
		  end
		end # Outputs zipfile as StringIO

		s3 = Aws::S3.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
		bucket = Aws::S3::Bucket.create(s3, ENV['S3_BUCKET_NAME'])

		compressed_filestream.rewind
		bucket.put("/app/public/uploads/#{slug}.zip", compressed_filestream.read, {}, 'authenticated-read')

	end

	def get_file_path
		return $uploads_path+"/#{self.get_slug}"
	end

	def get_slug
		return self.title.parameterize
	end
end
