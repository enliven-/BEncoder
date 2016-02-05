require 'BEncoder/version'

module BEncoder

  class BEncoder

    def encode obj
      case obj
      when String
        encode_string obj
      when Symbol
        encode_symbol obj
      end
    end


    private
      def encode_string str
        "#{ str.length }:#{ str }"
      end

      def encode_symbol symb
        encode_string symb.to_s
      end

  end
  
end
