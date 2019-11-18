require 'openapi_comment/configuration'
require 'openapi_comment/generator'
require 'openapi_comment/parser'
require 'openapi_comment/version'
require 'openapi_comment/models/comment'
require 'openapi_comment/models/openapi'
require 'openapi_comment/parsers/comment'
require 'openapi_comment/parsers/source'

module OpenapiComment
  class Error < StandardError; end

  class << self
    def setup
      yield configuration
    end

    def configuration
      @configuration ||= OpenapiComment::Configuration.new
    end
  end

  require 'openapi_comment/railtie' if defined?(::Rails::Railtie)
end
