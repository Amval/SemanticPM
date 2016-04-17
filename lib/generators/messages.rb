module Generators
  # Generates a list of messages from the following information
  # student [Models::Student]
  # candidate_concpt { concept => [root_concepts] } [ Hash of Strings]
  #

  # To resolve: Generates ONE message or EVERY message?
  class Messages
    attr_reader :data
    def initialize(params)
      @data = params[:data]
    end

    def create_messages
      self.data.each do |student_data|
        create_message(student_data)
      end
    end

    def create_message(student_data)
      student = find_student(student_data[:id])
      msg = generate_message(student_data)
      Message.create(student_id: student.id, content: msg)
    end

    def generate_message(student_data)
      "Hi, [#{student_data[:id]}]. It seems that you have read about #{student_data[:concept]}. Maybe you could write about it on the forums."
    end

    def find_student(original_id)
      Student.find_by(original_id: original_id)
    end
  end

end