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
      context 'when the trademark end in a vowel' do
        let(:trademark_name) { 'abcde' }

        it 'Generates 2 variations' do
          expect(perform).to eq(['bcd', 'abcd'])
        end
      end

      context 'when the trademark end in a consonant' do
        let(:trademark_name) { 'abcdf' }

        it 'Generates 6 variations' do
          expect(perform).to eq(['bcdf', 'abcdfa', 'abcdfe', 'abcdfi', 'abcdfo', 'abcdfu'])
        end
      end
    end

    context 'when the trademark has more than 1 words' do
      let(:trademark_name) { 'abc def ghi jkl mno' }

      it 'Generates the first, last, and first and last words' do
        expect(perform).to eq(["abc", "mno", "abc mno"])
      end
    end
  end
end
