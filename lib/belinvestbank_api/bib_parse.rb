#!/usr/bin/env ruby

module BelinvestbankApi
  class Parse
    def self.keyLang(text)
      if text =~ /keyLang":\[([^\]]+)/ then
        str = $1
        str.split(',').map {|e| e.to_i}
      end
    end
  end
end
