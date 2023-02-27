class TmviewClient
  BASE_URL = 'https://www.tmdn.org/tmview/api'
  USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '\
                 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36.'
  DEFAULT_TERRITORIES = %w[FR DE IT ES GB CL US AU].freeze

  def initialize(
    nice_classes: [],
    territories: DEFAULT_TERRITORIES,
    page_size: 50,
    fields: nil
  )
    @nice_classes_numbers = nice_classes.pluck(:number)
    @page_size = page_size
    @territories = territories
    @fields = fields || default_fields
  end

  def phonetic_search(brand_name)
    phonetic_criteria = 'F'

    build_brand_search(brand_name, phonetic_criteria)
  end

  def exact_search(brand_name)
    exact_criteria = 'E'

    build_brand_search(brand_name, exact_criteria)
  end

  private

  def trademark_results(response, searched_term)
    JSON.parse(response.body)['tradeMarks'].map do |trademark|
      Trademark.new(tm_data_hash: trademark, searched_term: searched_term)
    end
  end

  def build_brand_search(brand_name, criteria = 'F')
    body = {
      pageSize: @page_size,
      criteria: criteria,
      territories: @territories,
      basicSearch: brand_name,
      niceClass: formatted_nice_classes,
      fields: @fields
    }.to_json

    responses = brand_search_request(body)
    trademark_results(responses, brand_name)
  end

  def headers
    {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'referer': 'https://www.tmdn.org/tmview/',
      'Origin': 'https://www.tmdn.org',
      'User-Agent': USER_AGENT

    }
  end

  def brand_search_request(body)
    path = '/search/results'
    http_method = 'post'
    sent_tmview_request(http_method, path, headers, body)
  end

  def post_request(path, headers, body)
    HTTParty.post(
      path,
      headers: headers,
      body: body
    )
  end

  def sent_tmview_request(http_method, path, headers, body = {})
    uri = URI.parse(BASE_URL + path)
    case http_method

    when 'post'
      response = post_request(uri, headers, body)
    end

    check_invalid_response(response)
    response
  end

  def check_invalid_response(response)
    return unless response.code != 200

    raise "Tmview invalid response: #{response.code}"
  end

  def default_fields
    ["ST13", "markImageURI",
     "tmName", "tmOffice",
     "applicationNumber", "applicationDate",
     "tradeMarkStatus", "niceClass"]
  end

  def formatted_nice_classes
    @nice_classes_numbers.join(' OR ').split(' ')
  end
end
