module Generators
  class StudentCandidates
    attr_reader :students, :concept_candidates, :domain_model

    def initialize(params)
      # Posts ordered by number of posts
      # TODO: Take in account last contribution
      @students = params[:students].sort_by { |s| s.posts.size}
      deserialize_students_models

      @concept_candidates = params[:concept_candidates]
      @domain_model = params[:domain_model]
    end

    def deserialize_students_models
      # TODO: Fix that some Students don't have a model
      self.students.each do |student|
        student.deserialize_model
      end
    end

    def evaluate_all_students
      self.students.map { |student| evaluate_all_concept_candidates(student) unless student.model.nil?}
    end

    def evaluate_all_concept_candidates(student)
      self.concept_candidates.map do |key, value|
        evaluate_candidate_concept(student, key, value)
      end
    end

    def evaluate_candidate_concept(student, concept, roots)
      return Hash[concept, 0] unless student.has_concept?(concept)
      return Hash[concept, 0] if student.has_commented_concept?(concept)
      concept_knowledge_ratio = student.model[concept].weight / domain_model[concept].weight
      comments_scores = student.posts_scores_for(roots)
      # TODO: Fix so scores are stored as floats and map is not necessary
      score = concept_knowledge_ratio + comments_scores.map {|x| x.to_f}.reduce(:+)
      Hash[concept, score]
    end

  end
end