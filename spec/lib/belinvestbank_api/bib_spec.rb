require 'rails_helper'

require_relative "../../../lib/belinvestbank_api/bib_parse.rb"

describe BelinvestbankApi::Bib do
  let(:bib) { described_class.new Setting.bib_options }

  describe '.initialize' do
    it 'returns valid Bib instance' do
      expect(bib).not_to be_blank
      expect(bib).to be_kind_of(described_class)
    end
  end

  describe '.login' do
    context 'When invalid credentials' do
      it 'returns error' do
        # TODO mock http requests
        expect{ bib.login }.to raise_error(Socket::ResolutionError)
      end
    end
  end

  describe '.logout' do
    xit 'returns successful result' do

    end
  end

  describe '.encode_password' do
    xit 'returns encrypted_pass password' do

    end
  end
end
