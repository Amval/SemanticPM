class Student < ActiveRecord::Base
  belongs_to :course
  has_many :posts

  validates :course_id, presence: true
  validates :original_id, presence: true
  validates :accessed_learning_resources, presence: true
end
