require 'rails_helper'

RSpec.describe LoadNiceClassesFromCsvJob, type: :job do
  let(:csv_content) do
    <<~CSV
      number,short_description,explanatory_note
      1,Short description 1,Explanatory note 1
      2,Short description 2,Explanatory note 2
    CSV
  end

  context 'with valid csv file' do
    def perform
      described_class.perform_now(csv_content)
    end

    it 'creates nice classes' do
      expect { perform }.to change { NiceClass.count }.by(2)
    end

    it 'creates nice classes with correct attributes' do
      perform

      expect(NiceClass.first.number).to eq(1)
      expect(NiceClass.first.short_description).to eq('Short description 1')
      expect(NiceClass.first.explanatory_note).to eq('Explanatory note 1')
    end
  end
end
