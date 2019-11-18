module OpenapiComment
  module Parsers
    class CommentParser
      @properties = {
        openapi: {
          multiline: :yaml,
          args: [:version]
        },
        path: {},
        summary: {},
        description: {
          multiline: :description
        },
        tags: {
          args: :array
        },
        method: {},
        operation_id: {},
        request_bodies: {
          multiline: :description,
          multiple: true,
          args: [:schema, :media, {key: :required, type: :boolean, check: 'required'}]
        },
        responses: {
          multiline: :description,
          multiple: true,
          args: [:schema, :media, :status]
        },
        request_parameters: {
          multiline: :description,
          multiple: true,
          args: [:schema, :in, :name, {key: :required, type: :boolean, check: 'required'}]
        },
        securities: {
          multiline: :yaml,
          multiple: true,
          args: [:schema]
        },
        schemas: {
          multiline: :yaml,
          multiple: true,
          args: [:name]
        },
        deprecated: {
          type: :existence
        }
      }.freeze

      class << self

        # @param [String[]] comments
        # @return [Models::Comment]
        def parse(comments)
          result = Models::Comment.new
          checking = nil
          inline = nil
          return result if comments.nil? || comments.empty?
          comments.each do |comment|
            property = comment.match(/(?<=@)\w+/)&.[](0)&.to_sym
            if property.nil?
              checking = :description if result[:description].nil? && checking.nil?
              unless checking.nil?
                if result[checking].nil? || result[checking].is_a?(String)
                  result[checking] = [result[checking], comment].compact.join("\n")
                elsif result[checking].is_a?(Hash)
                  result[checking][inline] ||= ''
                  if inline == :description
                    result[checking][inline] << "#{comment.gsub(/^\s*/, '')}\n"
                  elsif inline == :yaml
                    result[checking][inline] << "#{comment}\n"
                  end
                elsif result[checking].is_a?(Array)
                  result[checking].last[inline] ||= ''
                  if inline == :description
                    result[checking].last[inline] << "#{comment.gsub(/^\s*/, '')}\n"
                  elsif inline == :yaml
                    result[checking].last[inline] << "#{comment}\n"
                  end
                end
              end
            else
              checking = nil
              if @properties.keys.include?(property)
                setting = @properties[property]
                unless setting[:multiline].nil?
                  checking = property
                  inline = setting[:multiline]
                end

                if setting[:type] == :existence
                  result[property] = true
                elsif setting[:args].nil?
                  if setting[:multiple]
                    result[property] ||= []
                    result[property] << line_parse(property, comment)
                  else
                    result[property] = line_parse(property, comment)
                  end
                else
                  if setting[:multiple]
                    result[property] ||= []
                    result[property] << args_parse(setting[:args], comment)
                  else
                    result[property] = args_parse(setting[:args], comment)
                  end
                end
              end
            end
          end
          parse_hash!(result)
        end

        private

        def parse_hash!(result)
          @properties.keys.each do |key|
            if @properties[key][:multiline] == :yaml && !result[key].nil?
              if @properties[key][:multiple]
                result[key] = result[key].map do |res|
                  res.merge!(struct: YAML.load(res[:yaml]))
                  res.delete(:yaml)
                  res
                end
              else
                result[key][:struct] = YAML.load(result[key][:yaml])
                result[key].delete(:yaml)
              end
            end
          end
          result
        end

        def line_parse(property, comment)
          comment.match(/(?<=@#{property}\s).+/)&.[](0)
        end

        def args_parse(args_setting, comment)
          args = comment.scan(/(?<=\[)[^\[\]]*(?=\])/)
          args ||= []
          if args_setting == :array
            args[0]&.split(',')
          elsif args_setting.is_a?(Array)
            args_setting.each_with_index.reduce({}) do |arg, (key, index)|
              if key.is_a?(Symbol)
                arg.merge(key => args[index])
              elsif key.is_a?(Hash)
                if key[:type] == :boolean
                  arg.merge(key[:key] => args[index] == key[:check])
                end
              end
            end
          end
        end
      end
    end
  end
end