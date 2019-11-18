module OpenapiComment
  module Parsers
    class Source
      class << self
        # @param [String] path
        def parse(path)
        class_inline = 0
        method_inline = 0
        class_name = nil
        comments = {}

        File.open(path, 'r').each do |line|
          if line.match?(/^\s*class\s/) || line.match?(/^\s*module\s/)
            class_name = line.match(/(?<=class\s)\w+/)&.[](0)
            class_name = line.match(/(?<=module\s)\w+/)&.[](0) if class_name.nil?
            comments[:current] = {methods: {}, comments: []} if comments[:current].nil?
            comments[class_name] = comments[:current]
            comments.delete(:current)
            class_inline += 1
          elsif line.match?(/^\s*def/)
            comments[class_name][:methods][line.match(/(?<=def\s)\w+/)[0]] = comments[class_name][:methods][:current]
            comments[class_name][:methods].delete(:current)
            method_inline += 1
          elsif (not line.match?(/^\s*#/)) && line.match?(/(^\s*if\s|\scase\s|\sdo\s|\swhile\s|\sfor\s|\s\|.+\|\s)/)
            method_inline += 1
          elsif line.match?(/^\s*end/)
            if method_inline > 0
              method_inline -= 1
            elsif class_inline > 0
              class_inline -= 1
            end
          elsif line.match?(/^\s*#/)
            if class_inline > 0 && method_inline == 0
              comments[class_name][:methods][:current] = [] if comments[class_name][:methods][:current].nil?
              comments[class_name][:methods][:current].push(line.match(/(?<=#\s).*(?=\n)/)&.[](0))
            else
              comments[:current] = {methods: {}, comments: []} if comments[:current].nil?
              comments[:current][:comments].push(line.match(/(?<=#\s).*(?=\n)/)&.[](0))
            end
          end
        end
        convert(comments)
      end

      private

      def convert(comments)
        Hash[comments.map { |key, value|
          [
            key,
            {methods: Hash[value[:methods].map { |k, v| [k, CommentParser.parse(v)] }],
             comments: CommentParser.parse(value[:comments])}
          ]
        }]
      end
      end
    end
  end
end