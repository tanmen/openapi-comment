namespace :openapi do
  desc "openapi document generate"
  task :generate do
    OpenapiComment::Generator.generate
  end
end