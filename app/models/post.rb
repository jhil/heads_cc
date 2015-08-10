require 'zip'
require 'aws'

class Post < ActiveRecord::Base
	belongs_to :user
	has_many :heads, :dependent => :destroy
	has_many :comments
	accepts_nested_attributes_for :heads, :allow_destroy => true 

	def create_zip
		slug = self.get_slug

		ls= exec("ls #{uploads_path}")
		puts "helo: #{uploads_path}"

		compressed_filestream = Zip::OutputStream.write_buffer do |zos|
			Dir["#{uploads_path}/**/**"].reject{|f|f==archive}.each do |file|
				zipfile.add(file.sub(path+'/',''),file)
			end

		end
		s3 = Aws::S3.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
		bucket = Aws::S3::Bucket.create(s3, ENV['S3_BUCKET_NAME'])

		compressed_filestream.rewind
		bucket.put("/app/public/uploads/#{slug}.zip", compressed_filestream.read, {}, 'authenticated-read')

	end # Outputs zipfile as StringIO

	def get_file_path
		return $uploads_path+"/#{self.get_slug}"
	end

	def get_slug
		return self.title.parameterize
	end
end

