module Generators
  class StudentCandidates
    attr_reader :students
    def initialize(params)
      @students = params[:students]
    end
  end
end