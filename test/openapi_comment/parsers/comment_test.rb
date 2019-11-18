require 'test_helper'

module OpenapiComment
  module Parsers
    class CommentTest < Minitest::Test
      def test_can_parse
        comments = [
          "this method is so long",
          "@openapi [3.0.2]",
          "  title: sample",
          "  version: 1.0.0",
          "  description: test",
          "@path /path",
          "@summary summary comment",
          "@method GET",
          "@tags [A,B,C]",
          "@operation_id test",
          "@request_bodies [Sample][application/json][required]",
          "  this request body is sample.",
          "@responses [Sample][application/json][200]",
          "  this response is sample.",
          "@request_parameters [Sample][path][name][required]",
          "  this parameter is sample.",
          "@securities [OAuth2]",
          "  - read",
          "  - write",
          "@security_schemas [OAuth2]",
          "  type: oauth2",
          "  flows:",
          "    authorizationCode:",
          "      authorizationUrl: https://example.com/oauth/authorize",
          "      tokenUrl: https://example.com/oauth/token",
          "      scopes:",
          "        read: Grants read access",
          "        write: Grants write access",
          "        admin: Grants access to admin operations",
          "@schemas [Model]",
          "  type: object",
          "  properties:",
          "    number:",
          "      type: number",
          "@deprecated"]

        result = CommentParser.parse(comments)

        assert_equal({version: '3.0.2',
                      struct: {'title' => 'sample',
                               'version' => '1.0.0',
                               'description' => 'test'}},
                     result.openapi)
        assert_equal '/path', result.path
        assert_equal 'this method is so long', result.description
        assert_equal 'summary comment', result.summary
        assert_equal 'GET', result.method
        assert_equal ['A', 'B', 'C'], result.tags
        assert_equal 'test', result.operation_id
        assert_equal [{media: 'application/json',
                       required: true,
                       schema: 'Sample',
                       description: "this request body is sample.\n"}], result.request_bodies
        assert_equal [{media: 'application/json',
                       status: '200',
                       schema: 'Sample',
                       description: "this response is sample.\n"}], result.responses
        assert_equal [{type: 'path',
                       name: 'name',
                       schema: 'Sample',
                       required: true,
                       description: "this parameter is sample.\n"}], result.request_parameters
        assert_equal [{schema: 'OAuth2', struct: ['read', 'write']}], result.securities
        assert_equal [{name: 'Model', struct: {'type' => 'object', 'properties' =>
          {'number' => {'type' => 'number', }}}}], result.schemas
        assert result.deprecated
      end

      def test_multi_description
        comments = ['this path is test.', 'so beautiful openapi.']

        result = CommentParser.parse(comments)

        assert_equal comments.join("\n"), result.description
      end

      def test_multi_description_type
        descriptions = ['this path is test.', 'so beautiful openapi.']
        comments = descriptions.map.with_index { |des, index| index == 0 ? "@description #{des}" : des }

        result = CommentParser.parse(comments)

        assert_equal descriptions.join("\n"), result.description
      end

      def test_description_override
        class_description = 'this method is so slow.'
        descriptions = ['this path is test.', 'so beautiful openapi.']
        comments =
          [class_description] +
            descriptions.map.with_index { |des, index| index == 0 ? "@description #{des}" : des }

        method = CommentParser.parse(comments)

        assert_equal descriptions.join("\n"), method.description
      end
    end
  end
end