require 'csv'

# TODO: Refactor this logic into components?
# Logic outside of the Model.

class Course < ActiveRecord::Base

  belongs_to :user
  has_one :domain, dependent: :destroy
  has_many :students, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
  mount_uploader :concepts, ConceptsUploader
  mount_uploader :activity_log, ActivityLogUploader
  mount_uploader :student_generated_content, StudentGeneratedContentUploader

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 140 }
  validates :concepts, presence: true

  #after_save :process_concepts, if: Proc.new { |course| !course.concept.url.nil? }
  after_save :create_domain
  after_save :create_students, unless: proc { |course| course.activity_log.nil? }

  def create_domain
    Generators::DomainModel.new(id, concepts)
  end

  def create_students
    Generators::StudentModel.new(id, activity_log)
  end
end
