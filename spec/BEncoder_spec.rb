require 'spec_helper'

describe BEncoder do

  let(:be) { BEncoder::BEncoder.new }


  it 'has a version number' do
    # expect(BEncoder::VERSION).not_to be nil
  end


  context 'strings:' do
    it 'encodes strings correctly' do
      expect(be.encode('welcome')).to eq('7:welcome')
    end

    it 'encodes empty string correctly' do
      expect(be.encode('')).to eq('0:')
    end
  end
  

  context 'symbols:' do
    it 'encodes symbols correctly' do
      expect(be.encode(:symbol)).to eq('6:symbol')
    end
  end

end
