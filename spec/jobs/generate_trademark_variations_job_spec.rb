require 'rails_helper'

RSpec.describe GenerateTrademarkVariationsJob, type: :job do
  describe '#perform' do
    def perform
      described_class.perform_now(trademark_name)
    end

    context 'when the trademark has less than 3 characters' do
      let(:trademark_name) { 'ab' }

      it { expect(perform).to eq(['ab']) }
    end

    context 'when the trademark has 3 characters or more' do
      let(:trademark_name) { 'abcde' }

      it 'Generates 4 variations' do
        expect(perform).to eq(['abcde', 'bcde', 'abcd', 'bcd', 'ae'])
      end
    end

    context 'when the trademark has between 2 and 4 words' do
      let(:trademark_name) { 'abc def ghi' }

      it 'Generates n words, and their combinations' do
        expect(perform).to eq(['abc def ghi', 'abc', 'def', 'ghi', 'abc def', 'abc ghi', 'def ghi'])
      end
    end

    context 'when the trademark has more than 4 words' do
      let(:trademark_name) { 'abc def ghi jkl mno' }

      it 'Generates the first, last, and first and last words' do
        expect(perform).to eq(["abc def ghi jkl mno", "abc", "mno", "abc mno"])
      end
    end
  end
end
