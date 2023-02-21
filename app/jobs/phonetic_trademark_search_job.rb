class PhoneticTrademarkSearchJob < ApplicationJob
  queue_as :default

  def perform(brand_name, nice_classes)
    @brand_name = brand_name
    @nice_classes = nice_classes

    return [] if @brand_name.blank?

    phonetic_search_results.sort_by(&:score).reverse
  end

  private

  def phonetic_search_results
    @phonetic_search_results ||= tmview_client.phonetic_search(@brand_name)
  end

  def tmview_client
    @tmview_client ||= TmviewClient.new(nice_classes: @nice_classes)
  end
end
