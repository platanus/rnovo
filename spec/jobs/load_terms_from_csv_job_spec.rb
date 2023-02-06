require 'rails_helper'

RSpec.describe LoadTermsFromCsvJob, type: :job do
  let(:csv_content) do
    <<~CSV
      reference_id,name
      1,Term 1
      2,Term 2
    CSV
  end

  context 'with valid nice class and csv file' do
    let(:nice_class) { create(:nice_class) }

    def perform
      described_class.perform_now(csv_content, nice_class.id)
    end

    it 'creates terms' do
      expect { perform }.to change { nice_class.terms.count }.by(2)
    end

    it 'creates terms with correct attributes' do
      perform

      expect(nice_class.terms.first.reference_id).to eq(1)
      expect(nice_class.terms.first.name).to eq('Term 1')
    end

    describe 'when term already exists' do
      let!(:term) { create(:term, nice_class: nice_class, reference_id: 1) }

      it 'does not create term' do
        expect { perform }.to change { nice_class.terms.count }.by(1)
      end
    end
  end

  context 'with invalid nice class' do
    let(:csv_file) { Tempfile.new('terms.csv') }

    before do
      csv_file.write(csv_content)
    end

    after do
      csv_file.close!
    end

    it 'does not create terms' do
      expect { described_class.perform_now(csv_file, 0) }.not_to (change { Term.count })
    end
  end
end
