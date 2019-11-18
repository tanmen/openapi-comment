require 'test_helper'

class GeneratorTest < Minitest::Test
  def setup
    OpenapiComment.setup do |config|
      config.output = "test/files/output/openapi.yml"
      config.targets = "test/files/{controllers,views}/**/*.{rb,jbuilder}"
    end
  end

  def test_generate
    OpenapiComment::Generator.generate
  end
end