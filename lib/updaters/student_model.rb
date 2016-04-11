module Updaters
  class StudentModel
    attr_accessor :student, :concepts_list

    def initialize(params)
      @student = params[:student]
      @concepts_list = params[:concepts_list]
      @scores = calculate_avg_score
      #@model = Models::StudentModel.from_json(student.model)
      # Save updated Model
      @student.posts_scores = @scores
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
        Hash[concepts_list.zip(avg)]
      end

      # Returns a hash containing all post scores for the Student.
      # { Concept => score }
      def get_post_scores
        self.student.posts.map { |post| post.scores}
      end

  end
end
