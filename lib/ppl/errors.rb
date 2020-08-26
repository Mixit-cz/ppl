module Ppl
  module Errors
    class Error < StandardError; end
    class AttributeRequired < Error; end
    class Configuration < Error; end
    class Type < Error; end
  end
end
