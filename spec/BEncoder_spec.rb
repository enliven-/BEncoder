require 'spec_helper'

describe BEncoder do

  let(:be) { BEncoder::BEncoder.new }


  it 'has a version number' do
    # expect(BEncoder::VERSION).not_to be nil
  end

  context 'encoding' do

    context 'strings:' do
      it 'encodes strings correctly' do
        expect(be.encode('welcome')).to eq('7:welcome')
      end

      it 'encodes empty string correctly' do
        expect(be.encode('')).to eq('0:')
      end
    end
    

    context 'symbols' do
      it 'encodes symbols correctly' do
        expect(be.encode(:symbol)).to eq('6:symbol')
      end
    end


    context 'numbers' do
      it 'encodes +ve integers correctly' do
        expect(be.encode(123)).to eq('i123e')
      end

      it 'encodes -ve integers correctly' do
        expect(be.encode(-123)).to eq('i-123e')
      end

      it 'encodes zero correctly' do
        expect(be.encode(00)).to eq('i0e')
      end
    end


    context 'arrays' do
      it 'encodes empty array correctly' do
        expect(be.encode([ ])).to eq('le')
      end

      it 'encodes simple arrays correctly' do
        expect(be.encode(['spam', 'eggs' ])).to eq('l4:spam4:eggse')
      end

      it 'encodes nested arrays correctly' do
        expect(be.encode(['spam', ['eggs']])).to eq('l4:spaml4:eggsee')
      end
    end


    context 'hashes' do
      it 'encodes hashes correctly' do
        expect(be.encode({ key1: 'val1', key2: 'val2' })).to eq('d4:key14:val14:key24:val2e')
      end

      it 'encodes complex hashes correctly' do
        expect(be.encode({ key1: 'val1', key2: ['hello', 'world'] })).to eq('d4:key14:val14:key2l5:hello5:worldee')
      end
    end

  end


  context 'decoding' do

    context 'strings' do
      it 'decodes strings correctly' do
        expect(be.decode('5:hello')).to eq('hello')
      end

      it 'decodes empty string correctly' do
        expect(be.decode('0:')).to eq('')
      end
    end


    context 'numbers' do
      it 'decodes +ve integers correctly' do
        expect(be.decode('i123e')).to eq(123)
      end

      it 'decodes -ve integers correctly' do
        expect(be.decode('i-123e')).to eq(-123)
      end

      it 'decodes zero correctly' do
        expect(be.decode('i0e')).to eq(0)
      end      
    end


  end

end
