class PhoneticTrademarkSearchJob < ApplicationJob
  queue_as :default

  def perform(brand_name, nice_classes)
    @brand_name = brand_name
    @nice_classes = nice_classes

    return [] if @brand_name.blank?

    trademark_results.uniq(&:application_number).sort_by(&:score).reverse
  end

  private

  def exact_search_results
    @exact_search_results ||= tmview_client.exact_search(@brand_name)
  end

  def phonetic_search_results
    @phonetic_search_results ||= tmview_client.phonetic_search(@brand_name)
  end

  def trademark_results
    @trademark_results ||= exact_search_results + phonetic_search_results
  end

  def tmview_client
    @tmview_client ||= TmviewClient.new(nice_classes: @nice_classes)
  end
end
