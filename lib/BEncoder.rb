require 'BEncoder/version'

module BEncoder

  class BEncoder

    def encode obj
      case obj
      when String
        encode_string obj
      when Symbol
        encode_symbol obj
      when Integer
        encode_integer obj
      end
    end


    private
      def encode_string str
        "#{ str.length }:#{ str }"
      end

      def encode_symbol symb
        encode_string symb.to_s
      end

      def encode_integer int
        "i#{ int }e"
      end

  end
  
end
