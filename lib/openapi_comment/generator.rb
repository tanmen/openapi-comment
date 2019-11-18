require 'to_simple_yaml'
require 'yaml'

module OpenapiComment
  class Generator
    class << self
      def generate
        comments = OpenapiComment::Parsers.parse(OpenapiComment.configuration.targets)

        open(OpenapiComment.configuration.output, 'w') { |f| f.write(comments.to_simple_yaml) }
      end
    end
  end
end