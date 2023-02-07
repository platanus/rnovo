require 'rails_helper'

RSpec.describe TmviewClient, type: :client do
  let(:nice_classes) { create_list(:nice_class, 3) }
  let(:tm_view_response) do
      {
        applicationDate: '2023-01-01T12:00:00.000Z',
        applicationNumber: '123456',
        detailImageURI: 'https://example.com/detail_image',
        markImageURI: 'https://example.com/mark_image',
        niceClass: nice_classes.pluck(:number),
        sT13: 'CL500000',
        tmName: 'Trademark Name',
        tmOffice: 'CL',
        tradeMarkStatus: 'Registered'
    }
  end
  let(:response) do
    instance_double(
      'response',
      body: {'tradeMarks': [tm_view_response]}.to_json,
      code: 200
    )
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

  before do
    allow(HTTParty).to receive(:post).and_return(response)
  end

  def format_nice_classes(nice_classes)
    nice_classes.pluck(:number).join(' OR ').split(' ')
  end

  describe '#phonetic_search' do
    let(:uri) { URI.parse("#{TmviewClient::BASE_URL}/search/results") }
    let(:body) do
      {
        pageSize: 50,
        criteria: 'F',
        offices: ['CL', 'WO'],
        territories: ['CL'],
        basicSearch: 'brand_name',
        niceClass: format_nice_classes(nice_classes),
        fields: default_fields
      }.to_json
    end

    before do
      described_class.new(nice_classes: nice_classes).phonetic_search('brand_name')
    end

    it 'calls HTTParty with the correct params' do
      expect(HTTParty).to have_received(:post).with(
        uri,
        headers: headers,
        body: body
      )
    end

    it 'returns the response body' do
      expect(described_class.new(nice_classes: nice_classes).phonetic_search('brand_name'))
        .to be_a(Array)
    end
  end

  describe '#exact_search' do
  let(:uri) { URI.parse("#{TmviewClient::BASE_URL}/search/results") }
  let(:body) do
    {
      pageSize: 50,
      criteria: 'E',
      offices: ['CL', 'WO'],
      territories: ['CL'],
      basicSearch: 'brand_name',
      niceClass: format_nice_classes(nice_classes),
      fields: default_fields
    }.to_json
  end

  before do
    described_class.new(nice_classes: nice_classes).exact_search('brand_name')
  end

  it 'calls HTTParty with the correct params' do
    expect(HTTParty).to have_received(:post).with(
      uri,
      headers: headers,
      body: body
    )
  end

  it 'returns the response body' do
    expect(described_class.new(nice_classes: nice_classes).exact_search('brand_name'))
      .to be_a(Array)
  end
end
end
