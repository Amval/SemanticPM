require 'csv'

class Course < ActiveRecord::Base
  attr_accessor :domain, :jarl

  belongs_to :user
  has_many :learning_resource

  default_scope -> { order(created_at: :desc) }
  mount_uploader :concept, ConceptUploader
  mount_uploader :activity_log, ActivityLogUploader
  mount_uploader :student_generated_content, StudentGeneratedContentUploader

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 140}

  #after_save :process_concepts, if: Proc.new { |course| !course.concept.url.nil? }

  def process_concepts
    url = get_absolute_path(concept.url)
    InputReader::learning_resources(url)
  end

  def get_absolute_path(url)
    "#{Dir.pwd}/public#{url}"
  end

  def prueba
    jarl
  end


end
