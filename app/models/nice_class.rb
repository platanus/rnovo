class NiceClass < ApplicationRecord
  has_many :terms, dependent: :destroy

end

# == Schema Information
#
# Table name: nice_classes
#
#  id                :bigint(8)        not null, primary key
#  number            :integer          not null
#  short_description :text
#  explanatory_note  :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_nice_classes_on_number  (number) UNIQUE
#
