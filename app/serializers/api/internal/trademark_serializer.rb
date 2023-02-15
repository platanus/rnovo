class Api::Internal::TrademarkSerializer < ActiveModel::Serializer
  type :trademark

  attributes(
    :trademark_name,
    :trademark_office,
    :application_number,
    :application_date,
    :trademark_status,
    :mark_image_uri,
    :detail_image_uri,
    :trademark_standard_code,
    :score,
    :nice_classes
  )

  def read_attribute_for_serialization(attr)
    object.send(attr)
  end
end
