require 'csv'

class Course < ActiveRecord::Base

  belongs_to :user
  has_many :students, dependent: :destroy
  store_accessor :learning_resources

  default_scope -> { order(created_at: :desc) }
  mount_uploader :concept, ConceptUploader
  mount_uploader :activity_log, ActivityLogUploader
  mount_uploader :student_generated_content, StudentGeneratedContentUploader

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 140}
  validates :concept, presence: true

  after_validation :process_concepts

  #after_save :process_concepts, if: Proc.new { |course| !course.concept.url.nil? }

  def process_concepts
    if !concept.url.nil?
      url = get_absolute_path(concept.url)
      InputReader::learning_resources(url)
    end
  end

  def get_absolute_path(url)
    "#{Dir.pwd}/public#{url}"
  end

  def process_activity_log
    if !activity_log.url.nil?
      url = get_absolute_path(activity_log)
      return InputReader::resources_usage(url)
    end
  end



end
