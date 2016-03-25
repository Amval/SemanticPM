module Generators
  class StudentModel < Base
    def initialize(course_id, uploader)
      super(course_id, uploader)
      create
    end

    def create
      student_data = process_activity_log
      student_data.each do |key, value|
        Student.create(
          course_id: course_id,
          original_id: key,
          accessed_learning_resources: value)
      end
    end
  end
end
