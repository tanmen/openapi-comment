
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "openapi_comment/version"

Gem::Specification.new do |spec|
  spec.name          = "openapi_comment"
  spec.version       = OpenapiComment::VERSION
  spec.authors       = ["tanmen"]
  spec.email         = ["yt.prog@gmail.com"]

  spec.summary       = "Comment base openapi document generator."
  spec.description   = "Comment base openapi document generator.\n" +
    "Generate openapi.yml for comment.\n" +
    "And generate test for openapi. (Coming soon)"
  spec.homepage      = "https://github.com/tanmen/openapi-comment.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "to_simple_yaml", "~> 1.0.8"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
