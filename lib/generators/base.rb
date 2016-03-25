module Generators
  class Base
    attr_reader :uploader, :course_id, :mounted_file
    def initialize(course_id, uploader)
      @course_id = course_id
      @uploader = uploader
      @mounted_file = uploader.mounted_as

      # Defines a method to process data file
      self.class.send(:define_method, "process_#{mounted_file}") do
        unless uploader.url.nil?
          url = "#{Dir.pwd}/public#{uploader.url}"
          return InputReader::send(mounted_file, url)
        end
      end
    end

    def create
    end
  end
end
