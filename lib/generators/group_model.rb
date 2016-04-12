module Generators
  # TODO: Refactor and comment
  class GroupModel < Base
    attr_accessor :resources, :posts, :scores
    def initialize(course_id, uploader)
      super(course_id, uploader)
      @resources = process_student_generated_content
      @posts = create_posts
      @scores = calculate_scores
      score_posts
      create_group
    end

    def create
      self.resources = process_student_generated_content
      self.posts = create_posts
      self.scores = calculate_scores
      score_posts
      create_group
    end

    private

      # Creates a Post model and saves into the DB frm the student_generated_content.
      # Every Post is associated to its corresponding Student.
      def create_posts
        posts = []
        resources.each do |post_data|
          # FIX: Student id nil
          student_id = Student.where(
            original_id: post_data["student_id"],
            course_id: course_id).pluck(:id)

          post_data['student_id'] = student_id[0].to_i
          posts << Post.create(post_data)
        end
        posts
      end

      # Assigns a vector score to every Post
      def score_posts
        posts.each_with_index do |post, i|
          post.scores = scores[i]
          post.save
        end
      end

      # Calculates the vector Score for every Post
      def calculate_scores
        posts_content = posts.map { |post| post.content }
        concepts_list = Course.find_by(id: course_id).domain.concepts_list
        Scoring::LogCount.new(posts_content, concepts_list).to_v
      end

      # Transform all vector scores (corresponding to each Post) into a single
      # one.
      def score_group
        self.scores.map { |vector| vector.reduce(:+) / vector.size.to_f }
      end

      # Creates Group Model
      def create_group
        Group.create(course_id: self.course_id, score: score_group)
      end


  end
end
