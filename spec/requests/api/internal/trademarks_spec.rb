require 'rails_helper'

RSpec.describe 'Api::Internal::TrademarkController', type: :request do
  describe 'GET /phonetic_search' do
    let(:tmview_client) { instance_double(TmviewClient, phonetic_search: []) }
    let(:params) { { trademark_name: 'MyString', nice_class_ids: [1, 2, 3] } }

    def perform
      get '/api/internal/trademarks/phonetic_search', params: params
    end

    before do
      allow(TmviewClient).to receive(:new).and_return(tmview_client)
      allow(tmview_client).to receive(:phonetic_search).and_return(['response'])
      perform
    end

    it 'calls TmviewClient#phonetic_search' do
      expect(tmview_client).to have_received(:phonetic_search)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /full_phonetic_search' do
    let(:params) { { trademark_name: 'MyString', nice_class_ids: [1, 2, 3] } }

    def perform
      get '/api/internal/trademarks/full_phonetic_search', params: params
    end

    before do
      allow(FullPhoneticTrademarkSearchJob).to receive(:perform_now).and_return(['response'])
      perform
    end

    it 'calls FullPhoneticTrademarkSearchJob#perform_now' do
      expect(FullPhoneticTrademarkSearchJob).to have_received(:perform_now)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end
  end
end
