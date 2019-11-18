require 'test_helper'

class ParserTest < Minitest::Test
  def test_parse
    files = OpenapiComment::Parsers.parse('test/files/controllers/tasks_controller.rb')
  end
end