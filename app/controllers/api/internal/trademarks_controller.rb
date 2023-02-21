class Api::Internal::TrademarksController < Api::Internal::BaseController
  def phonetic_search
    respond_with PhoneticTrademarkSearchJob.perform_now(
      brand_name,
      nice_classes
    ), each_serializer: Api::Internal::TrademarkSerializer
  end

  def full_phonetic_search
    respond_with FullPhoneticTrademarkSearchJob.perform_now(
      brand_name,
      nice_classes
    ), each_serializer: Api::Internal::TrademarkSerializer
  end

  private

  def trademark_search_params
    params.permit(:format, :trademark_name, nice_class_ids: [])
  end

  def brand_name
    @brand_name ||= trademark_search_params[:trademark_name]
  end

  def nice_classes
    @nice_classes ||= NiceClass.where(id: trademark_search_params[:nice_class_ids])
  end
end
