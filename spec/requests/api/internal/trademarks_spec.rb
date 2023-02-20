require 'rails_helper'

RSpec.describe 'Api::Internal::TrademarkController', type: :request do
  let!(:nice_classes) { create_list(:nice_class, 3) }
  let(:params) { { trademark_name: 'MyString', nice_class_ids: nice_classes.map(&:id) } }

  describe 'GET /phonetic_search' do
    def perform
      get '/api/internal/trademarks/phonetic_search', params: params
    end

    before do
      allow(PhoneticTrademarkSearchJob).to receive(:perform_now).and_return([])
      perform
    end

    it 'calls PhoneticTrademarkSearchJob#perform_now' do
      expect(PhoneticTrademarkSearchJob)
        .to have_received(:perform_now)
        .with('MyString', nice_classes)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /full_phonetic_search' do
    def perform
      get '/api/internal/trademarks/full_phonetic_search', params: params
    end

    before do
      allow(FullPhoneticTrademarkSearchJob).to receive(:perform_now).and_return([])
      perform
    end

    it 'calls FullPhoneticTrademarkSearchJob#perform_now' do
      expect(FullPhoneticTrademarkSearchJob)
        .to have_received(:perform_now)
        .with('MyString', nice_classes)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end
end
