module Generators
  # Generates a list of messages from the following information
  # student [Models::Student]
  # candidate_concpt { concept => [root_concepts] } [ Hash of Strings]
  #
  # IDEA: A generator for each student, makes more sense.
  class Messages
    attr_accessor :msg
    attr_reader :msg_info, :course_id, :domain, :student, :concept
    def initialize(params)
      @msg = ''
      @concept = params[:msg_info][:concept]
      @msg_info = params[:msg_info]
      @course_id = params[:course_id]
      @domain = params[:domain]
      self.domain.deserialize_model
      @student = find_student(msg_info[:id])
      self.student.deserialize_model
      create_message
    end

    # Creates and insert a message into the DB.
    def create_message
      generate_message
      Message.create(student_id: self.student.id, content: self.msg)
    end

    private

      # Returns a string with th content of the message
      def generate_message
        if self.student.has_knowledge_about?(self.concept)
          self.msg << "Hi, [#{self.student.original_id}]. It seems that you have read about #{self.concept}. Maybe you could write about it on the forums."
          enough_knowledge_about(self.msg_info[:concept])
        else
          self.msg << "Hi, [#{self.student.original_id}]. It seems that no one has written much about #{self.concept}, why don't you write something about it?"
          useful_resources = self.domain.in_which_learning_resources?(concept)
          recommend_new_resources(useful_resources)
        end
      end

      def enough_knowledge_about(concept, threshold = 0.6)
        domain_weight = self.domain.model.nodes[concept].weight
        # It's possible that the student has no knowlege about this concept
        student_weight = self.student.model.nodes[concept].weight
        if student_weight / domain_weight > threshold
          make_recommendations(concept)
        end
      end

      def make_recommendations(concept)
        useful_resources = self.domain.in_which_learning_resources?(concept)
        accessed_resources = self.student.accessed_learning_resources
        difference = useful_resources - accessed_resources
        recommend_new_resources(difference) if difference.size > 0
      end

      def recommend_new_resources(resources)
        message =  "
        You can improve your knowledge on the topic through the following resources:
        "
        self.msg << resources.each_with_object(message) { |r, message| message << " - [ResourceID: #{r}]"}
      end

      # Fin
      def find_student(original_id)
        Student.find_by(original_id: original_id, course_id: self.course_id)
      end
    end

end