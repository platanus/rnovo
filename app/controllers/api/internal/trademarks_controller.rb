class Api::Internal::TrademarksController < Api::Internal::BaseController
  def phonetic_search
    respond_with tmview_client.phonetic_search(trademark_search_params[:trademark_name])
  end

  def full_phonetic_search
    respond_with FullPhoneticTrademarkSearchJob.perform_now(
      trademark_search_params[:trademark_name],
      nice_classes
    )
  end

  private

  def trademark_search_params
    params.permit(:trademark_name, :nice_class_ids)
  end

  def nice_classes
    @nice_classes ||= NiceClass.where(id: trademark_search_params[:nice_class_ids])
  end

  def tmview_client
    @tmview_client ||= TmviewClient.new(nice_classes: nice_classes)
  end
end
