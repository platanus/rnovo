class Api::Internal::NiceClassSerializer < ActiveModel::Serializer
  type :nice_class

  attributes(
    :id,
    :number,
    :short_description,
    :explanatory_note
  )
end
