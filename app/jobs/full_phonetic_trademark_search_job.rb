class FullPhoneticTrademarkSearchJob < ApplicationJob
  queue_as :default

  def perform(brand_name, nice_classes)
    @brand_name = brand_name
    @nice_classes = nice_classes

    results = brand_name_variations.map do |variation|
      tmview_client.phonetic_search(variation)
    end

    results.flatten.uniq
  end

  private

  def brand_name_variations
    GenerateTrademarkVariationsJob.perform_now(@brand_name)
  end

  def tmview_client
    @tmview_client ||= TmviewClient.new(nice_classes: @nice_classes)
  end
end
