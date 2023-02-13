require 'rails_helper'

RSpec.describe Trademark, type: :value do
  subject(:trademark) do
    described_class.new(tm_data_hash: json_parsed_tm_data_hash, searched_term: searched_term)
  end

  before do
    Faker::UniqueGenerator.clear
  end

  let!(:nice_classes) { create_list(:nice_class, 3) }
  let(:tm_data_hash) do
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
    }.to_json
  end
  let(:json_parsed_tm_data_hash) { JSON.parse(tm_data_hash) }

  let(:searched_term) { 'Trademark Name' }

  describe '#nice_classes' do
    it 'returns an array of Nice classes' do
      expect(trademark.nice_classes).to eq(nice_classes.map(&:number))
    end
  end

  describe '#score' do
    it 'returns the score of likeness using the Levenshtein distance' do
      expect(trademark.score).to eq(100.0)
    end
  end

  describe '#trademark_name' do
    it 'returns the trademark name' do
      expect(trademark.trademark_name).to eq(json_parsed_tm_data_hash['tmName'])
    end
  end

  describe '#trademark_office' do
    it 'returns the trademark office' do
      expect(trademark.trademark_office).to eq(json_parsed_tm_data_hash['tmOffice'])
    end
  end

  describe '#application_number' do
    it 'returns the application number' do
      expect(trademark.application_number).to eq(json_parsed_tm_data_hash['applicationNumber'])
    end
  end

  describe '#application_date' do
    it 'returns the application date' do
      expect(trademark.application_date).to eq(json_parsed_tm_data_hash['applicationDate'])
    end
  end

  describe '#trademark_status' do
    it 'returns the trademark status' do
      expect(trademark.trademark_status).to eq(json_parsed_tm_data_hash['tradeMarkStatus'].downcase)
    end
  end

  describe '#mark_image_uri' do
    it 'returns the mark image uri' do
      expect(trademark.mark_image_uri).to eq(json_parsed_tm_data_hash['markImageURI'])
    end
  end

  describe '#detail_image_uri' do
    it 'returns the detail image uri' do
      expect(trademark.detail_image_uri).to eq(json_parsed_tm_data_hash['detailImageURI'])
    end
  end

  describe '#trademark_standard_code' do
    it 'returns the trademark standard code' do
      expect(trademark.trademark_standard_code).to eq(json_parsed_tm_data_hash['sT13'])
    end
  end
end


