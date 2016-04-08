module Updaters
  class StudentModel
    attr_accessor :student

    def initialize(params)
      @student = params[:student]
      #@concepts_list = params[:concepts_list]
      @scores = calculate_avg_score
      #@model = Models::StudentModel.from_json(student.model)
      # Save updated Model
      @student.posts_score = @scores
      @student.save
    end

    private

      # TODO: Better way of scoring/ combining.
      # Retuns one vector score from all the post vector scors.
      def calculate_avg_score
        posts_scores = get_post_scores
        # Combines all post scores into one
        sum = posts_scores.transpose.map {|x| x.reduce(:+)}
        # Divides by the number of posts
        avg = sum.map {|x| x > 0 ? x / sum.size.to_f : 0 }
        # Returns
      end

      # Returns an Array containing all post scores for the Student.
      def get_post_scores
        self.student.posts.map { |post| post.scores}
      end

      def update_model


      end
  end
end
