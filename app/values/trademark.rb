class Trademark
  attr_reader :trademark_name, :trademark_office, :application_number,
              :application_date, :trademark_status, :mark_image_uri,
              :detail_image_uri, :trademark_standard_code, :score,
              :nice_classes

  def initialize(tm_data_hash: {}, searched_term: '')
    @tm_data_hash = tm_data_hash
    @searched_term = searched_term

    @nice_classes = @tm_data_hash['niceClass']
    @trademark_name = @tm_data_hash['tmName']
    @trademark_office = @tm_data_hash['tmOffice']
    @application_number = @tm_data_hash['applicationNumber']
    @application_date = @tm_data_hash['applicationDate']
    @mark_image_uri = @tm_data_hash['markImageURI']
    @detail_image_uri = @tm_data_hash['detailImageURI']
    @trademark_standard_code = @tm_data_hash['sT13']
    @trademark_status = @tm_data_hash['tradeMarkStatus'].downcase
    @score = compute_trademark_term_score
  end

  private

  def compute_levenshtein_distance
    Levenshtein.distance(normalized_trademark_name, normalized_searched_term)
  end

  def normalized_searched_term
    I18n.transliterate(@searched_term.downcase)
  end

  def normalized_trademark_name
    I18n.transliterate(@trademark_name.downcase)
  end

  def trademark_levenstein_score
    [(compute_levenshtein_distance / normalized_searched_term.length.to_f), 0.9].min
  end

  def compute_trademark_term_score
    (100 * (1 - trademark_levenstein_score)).round(2)
  end
end
