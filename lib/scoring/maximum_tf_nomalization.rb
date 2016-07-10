module Scoring
  class MaximumTfNormalization < ScoreBase
    attr_accessor :score_matrix, :group_score
    def initialize(collection, query)
      super(collection, query)
      @score_matrix = calculate_score_matrix
      @group_score = calculate_group_score
    end

    # Transforms the tf_matrix into a score matrix using maximum tf normalization
    # as a Weighting Scheme
    def calculate_score_matrix(a = 0.4)
      tf_matrix.to_a.map do |v|
        tf_max = v.max
        v.map do |tf_t|
          if tf_max > 0
            a + (1 - a) * ( tf_t / tf_max)
          else
            0
          end
        end
      end
    end

    # Reduces the matrix into a single vector by adding all the columns and
    # then dividides by the avg number
    def calculate_group_score
      score_matrix.transpose.to_a.map {|v| v.reduce(&:+).to_f / v.size}
    end

  end
end