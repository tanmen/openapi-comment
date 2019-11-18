module OpenapiComment
  module Models
    class Comment < Struct.new(:openapi,
                               :path,
                               :description,
                               :summary,
                               :method,
                               :tags,
                               :operation_id,
                               :request_bodies,
                               :responses,
                               :request_parameters,
                               :securities,
                               :schemas,
                               :deprecated)
    end
  end
end