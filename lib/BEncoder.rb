require 'BEncoder/version'
require 'stringio'


class InvalidEncodingError < StandardError; end
class UnencodableTypeError < StandardError; end



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
      else
        raise UnencodableTypeError, "Cannot encode instance of type #{obj.class}"
      end
    end

    def decode str
      case str.chars.first
      when 'i'
        decode_integer str
      when 'l'
        decode_array str
      when 'd'
        decode_hash str
      else
        decode_string str
      end  
    end


    private


      # Encode helpers

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


      # Decode helpers

      def decode_string str
        length, data = str.split(':', -1)

        unless length.to_i == data.length
          raise InvalidEncodingError, "String length mismatch. Expected #{length.to_i}; got #{data.length}"
        end

        data
      end


      def decode_integer str
        
        unless str.start_with?('i') && str.end_with?('e')
          raise InvalidEncodingError, "Ill formatted integer"
        end

        str.slice(1..-2).to_i
      end


      def decode_array str
        
        if str.is_a? String
          unless str.start_with?('l') && str.end_with?('e')
            raise InvalidEncodingError, "Ill formatted array/list"
          end
          sio = StringIO.new(str.slice(1..-2))
        
        elsif str.is_a? StringIO
          sio = str
        end

        decode_iter(sio, [])
      end


      def decode_hash str

        if str.is_a? StringIO
          str.getc if peek(str) == 'd'
          key_val_arr = decode_array(str)
        elsif str.start_with?('d') && str.end_with?('e')
          key_val_arr = decode_array("l#{ str.slice(1..-2) }e")
        else
          raise InvalidEncodingError, "Ill formatted hash"
        end

        make_hash(key_val_arr)
      end


      def decode_iter io, container
        io.getc if peek(io) == 'l'

        until peek(io) == 'e' || io.eof?
          case peek(io)
          when 'i'
            container << decode_integer(io.gets sep='e')
          when 'l'
            container << decode_array(io)
          when 'd'
            container << decode_array(io)
          when ->(e) { e =~ /\d/ }
            length = io.gets(sep=':').to_i
            container << io.gets(length)
          else
            raise InvalidEncodingError, "Encountered unexpected identifier #{ peek(io) }"
          end
        end
        io.getc

        container
      end


      def make_hash arr
        hash = {}
        arr.each_slice(2) do |k,v|
          hash[k] = v
        end
        hash
      end


      def peek io
        char = io.getc
        io.ungetc char
        char
      end
  end
  
end
