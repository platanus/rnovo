class CreateTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :terms do |t|
      t.integer :reference_id
      t.string :name
      t.references :nice_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
