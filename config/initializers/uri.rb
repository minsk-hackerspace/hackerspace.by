module URI
  module Escape
    def escape(*arg)
      DEFAULT_PARSER.escape(*arg)
    end

    alias encode escape
  end
  extend Escape
end