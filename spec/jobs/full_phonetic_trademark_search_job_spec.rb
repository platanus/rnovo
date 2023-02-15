require 'rails_helper'

RSpec.describe FullPhoneticTrademarkSearchJob, type: :job do
  let(:tmview_client) { instance_double(TmviewClient, phonetic_search: []) }

  before do
    allow(TmviewClient).to receive(:new).and_return(tmview_client)
    allow(GenerateTrademarkVariationsJob)
      .to receive(:perform_now)
      .and_return(['variation1', 'variation2'])
  end

  describe '#perform' do
    let(:brand_name) { 'brand_name' }
    let(:nice_classes) { [create(:nice_class)] }

    it 'calls GenerateTrademarkVariationsJob' do
      described_class.perform_now(brand_name, nice_classes)
      expect(GenerateTrademarkVariationsJob).to have_received(:perform_now).with(brand_name)
    end

    it 'calls TmviewClient#phonetic_search' do
      described_class.perform_now(brand_name, nice_classes)
      expect(tmview_client).to have_received(:phonetic_search).twice
    end

    it 'returns an array' do
      expect(described_class.perform_now(brand_name, nice_classes)).to be_a(Array)
    end
  end
end
