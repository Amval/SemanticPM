class Student < ActiveRecord::Base
  belongs_to :course
  has_many :posts, dependent: :destroy

  validates :course_id, presence: true
  validates :original_id, presence: true
  validates :accessed_learning_resources, presence: true
  after_create :create_model, unless: Proc.new { |student| student.accessed_learning_resources.size < 2 }

  def create_model
    learning_resources = get_learning_resources
    model = Models::StudentModel.new(learning_resources)
    self.model = ActiveSupport::JSON.encode(model)
    self.save
  end

  def get_learning_resources
    # Is this optimal? Does one or two queries to the DB? Could it be done in one?
    course = Course.find_by(id: self.course_id)
    learning_resources = course.domain.learning_resources
    # Rails method. Doesn't accept array as argument
    learning_resources.slice(*self.accessed_learning_resources)
  end

end
