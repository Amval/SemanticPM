# TODO: Refactor and comment.
# This is a mess...
# Determine public and private interface
# It's possible that I have to redo it anyway, since TfIdf based mthods
# are really stupid for this use case...

# Contains scoring related classes.
module Scoring
  # Base class for scoring methods. Allows for the implementation of different
  # strategies
  class ScoreBase
    attr_accessor :posts, :query_mask, :scores
    attr_reader :collection, :query, :strategy, :tk

    def initialize(collection, query)
      @collection = collection
      # List of words to look for in text
      @query = query
      options = {
        punctuation: :none,
        expand_contractions: true
      }
      @tk = PragmaticTokenizer::Tokenizer.new(options)
      # Query vector with initial 0 scores
      @query_mask = vector_mask
      # Tokenised collection
      @posts = process_collection
      @scores = {}
    end

    def process_collection
      collection.map { |doc| tk.tokenize(doc).map(&:downcase) }
    end

    def vector_mask
      query.each_with_object({}) { |concept, hash| hash[concept] = 0}
    end

     def text_to_vector(post)
      mask = query_mask.clone
      post.each do |word|
        mask[word] += 1 if mask.include? word
      end
      mask
    end

    def zip_scores
      Matrix[*scores.values].transpose.to_a
    end

    def score_collection
      raise NotImplementedError, "Instance a subclass "
    end

    # The scores are stored as follows:
    # concept_a => [1..n]
    # concept_z => [1..n]
    # This functions joins all the score arrays into a Matrix and transposes
    # them. The result is a collection of arrays, which represent the scores for
    # the Query for every document in Collection
    def to_v
      Matrix[*scores.values].transpose.to_a
    end

  end
end


