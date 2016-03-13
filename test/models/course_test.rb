require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @course = @user.courses.build(name: "Example course")
  end

  test "should be valid" do
    assert @course.valid?
  end

  test "user id should be present" do
    @course.user_id = nil
    assert_not @course.valid?
  end

  test "name should be present" do
    @course.name = "  "
    assert_not @course.valid?
  end

  test "name should be at most 140 characters" do
    @course.name = "a" * 141
    assert_not @course.valid?
  end

  test "name should be at least 6 characters" do
    @course.name = "a" * 5
    assert_not @course.valid?
  end

  test "order should be most recent first" do
    assert_equal courses(:most_recent), Course.first
  end
end
