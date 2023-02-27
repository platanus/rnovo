require 'rails_helper'

RSpec.describe TmviewClient, type: :client do
  let(:nice_classes) do
    [
      create(:nice_class, number: '35'),
      create(:nice_class, number: '45')
    ]
  end
  let(:headers) do
    {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'referer': 'https://www.tmdn.org/tmview/',
      'Origin': 'https://www.tmdn.org',
      'User-Agent': TmviewClient::USER_AGENT
    }
  end
  let(:default_fields) do
    ["ST13", "markImageURI",
     "tmName", "tmOffice",
     "applicationNumber", "applicationDate",
     "tradeMarkStatus", "niceClass"]
  end

  def format_nice_classes(nice_classes)
    nice_classes.join(' OR ').split(' ')
  end

  describe '#phonetic_search' do
    let(:uri) { URI.parse("#{TmviewClient::BASE_URL}/search/results") }
    let(:body) do
      {
        pageSize: 50,
        criteria: 'F',
        territories: ['CL'],
        niceClass: format_nice_classes(nice_classes),
        fields: default_fields
      }.to_json
    end

    def post
      described_class.new(nice_classes: nice_classes).phonetic_search('Platanus')
    end

    it 'returns a array' do
      VCR.use_cassette('tmview_client/phonetic_search') do
        expect(post).to be_a(Array)
      end
    end

    it 'returns a array of Trademark' do
      VCR.use_cassette('tmview_client/phonetic_search') do
        expect(post.first).to be_a(Trademark)
      end
    end
  end

  describe '#exact_search' do
    let(:uri) { URI.parse("#{TmviewClient::BASE_URL}/search/results") }
    let(:body) do
      {
        pageSize: 50,
        criteria: 'E',
        territories: ['CL'],
        basicSearch: 'Platanus',
        niceClass: format_nice_classes(nice_classes),
        fields: default_fields
      }.to_json
    end

    def post
      described_class.new(nice_classes: nice_classes).exact_search('Platanus')
    end

    it 'returns a array' do
      VCR.use_cassette('tmview_client/exact_search') do
        expect(post).to be_a(Array)
      end
    end

    it 'returns a array of Trademark' do
      VCR.use_cassette('tmview_client/exact_search') do
        expect(post.first).to be_a(Trademark)
      end
    end
  end
end
