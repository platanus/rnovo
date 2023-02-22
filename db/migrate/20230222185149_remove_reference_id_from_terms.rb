class RemoveReferenceIdFromTerms < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :terms, :reference_id, :integer }
  end
end
