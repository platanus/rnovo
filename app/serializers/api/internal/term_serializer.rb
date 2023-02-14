class Api::Internal::TermSerializer < ActiveModel::Serializer
  type :term

  attributes(
    :id,
    :reference_id,
    :name,
    :nice_class_id
  )

  belongs_to :nice_class
end
