begin
  require 'json'
rescue StandardError => exception
  puts exception
end

#
#
#
module Features
  def convert_class_json(obj)
    JSON.pretty_generate obj
  end

#
#
  module ClassMethods
  end

  def self.included(klass)
    klass.extend ClassMethods
  end
end
