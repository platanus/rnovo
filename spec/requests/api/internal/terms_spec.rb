require 'rails_helper'

RSpec.describe 'Api::Internal::TermsControllers', type: :request do
  describe 'GET /index' do
    let!(:terms) { create_list(:term, 5) }
    let!(:term) { create(:term, name: 'Other') }
    let(:collection) { JSON.parse(response.body)['terms'] }
    let(:params) { { name: "MyString" } }

    def perform
      get '/api/internal/terms', params: params
    end

    before do
      perform
    end

    it { expect(collection.count).to eq(5) }
    it { expect(response.status).to eq(200) }
  end
end
