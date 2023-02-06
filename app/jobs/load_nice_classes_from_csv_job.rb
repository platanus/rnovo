class LoadNiceClassesFromCsvJob < ApplicationJob
  queue_as :default

  def perform(csv_content)
    return if csv_content.blank?

    NiceClass.transaction do
      CSV.parse(csv_content, headers: true) do |row|
        number = row['number'].to_i
        short_description = row['short_description']
        explanatory_note = row['explanatory_note']

        NiceClass.find_or_create_by(number: number) do |nice_class|
          nice_class.short_description = short_description
          nice_class.explanatory_note = explanatory_note
        end
      end
    end
  end
end
