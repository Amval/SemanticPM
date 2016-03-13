#require './resources_processor'
#require './graph'

module Models
  # Base Class for the Domain and User models. Transforms a collection of
  # dictionaries (pairs concept-score) into an Affiliation Network.
  #
  # @attr [Array of Hashes]
  class SemanticModel < Graph
  require 'matrix'

    attr_reader :resources, :keywords, :matrix, :matrix_t

    def initialize(*resources)
      @resources = *resources
      @keywords = collect_keywords
      @matrix = Matrix.rows(resources.map { |resource| generate_row(resource) })
      @matrix_t = matrix.transpose
      # @TODO Composition instead of inheritance
      super(keywords, keywords_matrix)
    end

    # Extract keywords (order of appearance)
    #
    def collect_keywords
      resources.map(&:keys).flatten.uniq
    end

    def generate_row(resource)
      keywords.map { |key| resource[key] || 0 }
    end

    def keywords_matrix
      (matrix_t * matrix).round(3)
    end

    #def resources_matrix
    #  matrix * matrix_t
    #end

  end
end

