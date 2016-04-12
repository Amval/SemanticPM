require 'csv'

# TODO: Refactor this logic into components?
# Logic outside of the Model.

class Course < ActiveRecord::Base
  # Relationships
  belongs_to :user
  has_one :domain, dependent: :destroy
  has_one :group, dependent: :destroy
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
  after_save :create_students, unless: Proc.new { |course| course.activity_log.url.nil? }
  after_save :create_group, unless: Proc.new { |course| course.student_generated_content.url.nil? }
  after_save :update_domain, unless: Proc.new { |course| course.group.nil?}
  after_save :update_students

  # TODO: named parameters?
  def create_domain
    Generators::DomainModel.new(self.id, self.concepts)
  end

  def create_students
    Generators::StudentModel.new(self.id, self.activity_log)
  end

  def create_group
    Generators::GroupModel.new(self.id, self.student_generated_content)
  end

  # TODO: Pass domain and group directly. This way is decoupled from DB.
  def update_domain
    Updaters::DomainModel.new(self.domain.id, self.group.id, 0.1)
  end

  def update_students
    concepts_list = self.domain.concepts_list
    self.students.each do |student|
      Updaters::StudentModel.new(student: student , concepts_list: concepts_list)
    end
  end

  def generate_candidates
    # To avoid querying the db twice?
    domain_model = self.domain.model
    cc = Generators::ConceptCandidates.new(domain_model: domain_model)
    sc = Generators::StudentCandidates.new(
      students: self.students,
      concept_candidates: cc.candidates,
      domain_model: domain_model)
    sc.evaluate_all_students
  end
end
