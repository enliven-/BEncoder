require 'BEncoder/version'

module BEncoder

  class BEncoder
    def encode obj
      case obj
      when String
        encode_string obj
      end
    end


    private
      def encode_string str
        "#{ str.length }:#{ str }"
      end
  end
  
end
