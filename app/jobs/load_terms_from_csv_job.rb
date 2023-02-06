require 'csv'

class LoadTermsFromCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_content, nice_class_id)
    @nice_class = NiceClass.find_by(id: nice_class_id)
    return unless @nice_class.present? && csv_content.present?

    Term.transaction do
      CSV.parse(csv_content, headers: true) do |row|
        reference_id = row['reference_id'].to_i
        name = row['name']

        @nice_class.terms.find_or_create_by(reference_id: reference_id) do |term|
          term.name = name
        end
      end
    end
  end
end
