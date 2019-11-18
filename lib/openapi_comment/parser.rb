module OpenapiComment
  module Parsers
    class << self
      def parse(path)
        openapi = {
          openapi: '',
          info: {},
          tags: [],
          paths: {},
          components: {
            schemas: {}
          }
        }
        sources = Dir.glob(path).map { |src| Source.parse(src) }

        sources.each do |source|
          source.values.each do |klass|
            unless klass[:comments].openapi.nil?
              openapi[:openapi] = klass[:comments].openapi[:version]
              openapi[:info] = klass[:comments].openapi[:struct]
            end

            if (not klass[:comments].schemas.nil?) && (not klass[:comments].schemas.empty?)
              openapi[:components][:schemas]
                .merge!(klass[:comments].schemas
                          .reduce({}) { |schemas, schema| schemas.merge({schema[:name] => schema[:struct]}) })
            end

            klass[:methods].values.each do |method|
              if validate_comment method
                tags = (klass[:comments].tags || []) + (method.tags || [])
                openapi[:tags] = (openapi[:tags] + tags.map { |tag| {name: tag} }).uniq
                openapi[:paths].merge!(merge_path(klass[:comments].path, method.path) => {
                  method.method&.downcase => convert(method, tags)
                })
              end
              if (not method.schemas.nil?) && (not method.schemas.empty?)
                openapi[:components][:schemas]
                  .merge!(method.schemas
                            .reduce({}) { |schemas, schema| schemas.merge({schema[:name] => schema[:struct]}) })
              end
            end
          end
        end
        openapi
      end

      private

      def merge_path(parent, current)
        "/#{(parent&.split('/') || [])&.concat(current&.split('/') || [])
              &.delete_if { |i| ["", nil].include?(i) }&.join('/')}"
      end

      # @param [Models::Comment] comment
      def validate_comment(comment)
        (not comment.path.nil?) &&
          (not comment.method.nil?) &&
          (not comment.responses.nil?) &&
          (comment.responses.length > 0)
      end

      # @param [Models::Comment] comment
      def convert(comment, tags)
        {
          summary: comment.summary,
          description: comment.description,
          operationId: comment.operation_id,
          tags: tags,
          parameters: convert_parameters(comment.request_parameters),
          deprecated: comment.deprecated,
          responses: comment.responses.reduce({}) { |all, res| all.merge(convert_response(res)) }
        }
      end

      def convert_parameters(params)
        return nil if params.nil? || params.empty?
        params.map { |p| {**p, schema: {'$ref': "#/components/schemas/#{p[:schema]}"}} }
      end

      def convert_response(res)
        {res[:status] => {
          description: res[:description],
          content: {
            res[:media] => {
              schema: {
                '$ref' => "#/components/schemas/#{res[:schema]}"
              }
            }
          }
        }}
      end
    end
  end
end