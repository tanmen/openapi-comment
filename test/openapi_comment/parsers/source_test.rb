require 'test_helper'

module OpenapiComment
  module Parsers
    class SourceTest < Minitest::Test
      def test_parse_source
        parsed = Source.parse('test/files/controllers/users_controller.rb')
      end

      def test_parse_view
        parsed = Source.parse('test/files/views/create.jbuilder')
      end
    end
  end
end