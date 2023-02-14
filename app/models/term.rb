class Term < ApplicationRecord
  include PgSearch::Model

  belongs_to :nice_class

  pg_search_scope :search_by_name, against: :name, using: :trigram, ignoring: :accents
end

# == Schema Information
#
# Table name: terms
#
#  id            :bigint(8)        not null, primary key
#  reference_id  :integer
#  name          :string
#  nice_class_id :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_terms_on_nice_class_id  (nice_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (nice_class_id => nice_classes.id)
#
