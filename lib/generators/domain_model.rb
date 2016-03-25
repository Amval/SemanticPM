module Generators
  class DomainModel < Base
    def initialize(course_id, uploader)
      super(course_id, uploader)
      create
    end

    def create
      resources = process_concepts
      domain_model = Models::DomainModel.new(resources)
      json_domain = ActiveSupport::JSON.encode(domain_model)
      Domain.create(
        course_id: course_id,
        learning_resources: resources,
        concepts_list: domain_model.node_names,
        model: json_domain)
    end
  end
end
