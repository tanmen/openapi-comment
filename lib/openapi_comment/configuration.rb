module OpenapiComment
  class Configuration < Struct.new(:input, :output, :targets)
    def initialize(output = 'doc/openapi.yml', targets = 'app/{controllers,views}/**/*.{rb,jbuilder}')
      self.output = output
      self.targets = targets
    end
  end
end