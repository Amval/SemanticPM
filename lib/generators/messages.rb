module Generators
  # Generates a list of messages from the following information
  # student [Models::Student]
  # candidate_concpt { concept => [root_concepts] } [ Hash of Strings]
  #

  # To resolve: Generates ONE message or EVERY message?
  class Messages

    def initialize(params)
      @student = params[:student]
      @candidate_concept = params[:candidate_concept]
    end

  end

end