
require 'csv'

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# Write the code in a way that can be executed multiple times without duplicating the information.

nice_classes_content = File.read('lib/seeds/nice_classes.csv')
LoadNiceClassesFromCsvJob.perform_now(nice_classes_content)

terms_filename_format = 'lib/seeds/class_%s_terms.csv'

NiceClass.all.each do |nice_class|
  terms_content = File.read(terms_filename_format % nice_class.number)

  LoadTermsFromCsvJob.perform_now(terms_content, nice_class.id)
end
