require 'rails_helper'

RSpec.describe PhoneticTrademarkSearchJob, type: :job do
  let(:tmview_client) { instance_double(TmviewClient, phonetic_search: [], exact_search: []) }

  before do
    allow(TmviewClient).to receive(:new).and_return(tmview_client)
  end

  describe '#perform' do
    let(:brand_name) { 'brand_name' }
    let(:nice_classes) { [create(:nice_class)] }

    it 'calls TmviewClient#phonetic_search' do
      described_class.perform_now(brand_name, nice_classes)
      expect(tmview_client).to have_received(:phonetic_search)
    end

    it 'calls TmviewClient#exact_search' do
      described_class.perform_now(brand_name, nice_classes)
      expect(tmview_client).to have_received(:exact_search)
    end

    it 'returns an array' do
      expect(described_class.perform_now(brand_name, nice_classes)).to be_a(Array)
    end
  end
end
