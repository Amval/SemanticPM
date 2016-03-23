module CoursesHelper
  def has_file?(file)
    !file.url.nil?
  end
end
