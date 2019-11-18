$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "openapi_comment"
require "to_simple_yaml"
Dir.glob("#{__dir__}/mocks/**/*.rb").each {|file| require file}

require "minitest/autorun"
