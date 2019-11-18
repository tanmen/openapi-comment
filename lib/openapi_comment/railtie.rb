module OpenapiComment
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "tasks/document.rake"
    end
  end
end