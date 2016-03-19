class CoursesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @course = current_user.courses.build(course_params)
    @course.learning_resources = @course.process_concepts

    if @course.save
      data = @course.process_activity_log
      create_students(data) if !data.nil?

      flash[:success] = @course.students
      redirect_to current_user
    else
      flash[:error] = "Course not created"
      redirect_to current_user
    end

  end

  def destroy

  end



  private
    def course_params
      params.require(:course).permit(:name, :concept, :activity_log, :student_generated_content)
    end

    def get_absolute_path(url)
      "#{Dir.pwd}/public#{url}"
    end

    def create_students(hash)
      hash.each do |key, value|
        @course.students.create(original_id: key, learning_resources: value)
      end
    end
end
