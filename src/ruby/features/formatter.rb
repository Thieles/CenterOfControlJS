begin
  require "rdoc/markup"
  require "rdoc/markup/to_html"
rescue => exception
  
end
module Features
  module Formatter
    class UnknownFormatterError < StandardError; end

    class Base
      attr_accessor :content
      def initialize(content)
        @content = content
      end

      def to_html
        raise Formatter::AbstractMethodError
      end

      def self.inherited(child)
        type = child.name.split("::").last.downcase.to_sym
         Formatter::FORMATTERS[type] = child.name
      end
    end

    FORMATTERS = {}

    def self.format(type, content)
      formatter_name = FORMATTERS[type.to_sym]
      raise UnknownFormatterError unless formatter_name
      formatter = eval formatter_name
      formatter.new(content).to_html
    end
  end

  class Textile < Base
    def to_html
      RedCloth.new(content).to_html
    end
  end

  class Markdown < Base
    def to_html
      RDiscount.new(content).to_html
    end
  end

  class Rdoc < Base
    def to_html
      RDoc::Markup::ToHtml.new.convert content
    end
  end
end
