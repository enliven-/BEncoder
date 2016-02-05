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
      when Array
        encode_array obj
      when Hash
        encode_hash obj
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

      def encode_array arr
        arr.inject('l') { |result, el| result += encode(el) } + 'e'
      end

      def encode_hash hash
        hash.inject('d') { |result, (k,v)| result += "#{ encode(k) }#{ encode(v) }" } + 'e'
      end

  end
  
end
