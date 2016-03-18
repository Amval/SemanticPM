class CoursesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @course = current_user.courses.build(course_params)
    if @course.save
      prueba = @course.process_concepts
      flash[:success] = prueba

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
end
