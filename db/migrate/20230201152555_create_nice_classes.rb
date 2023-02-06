class CreateNiceClasses < ActiveRecord::Migration[6.1]
  def change
    create_table :nice_classes do |t|
      t.integer :number, index: { unique: true }, null: false
      t.text :short_description
      t.text :explanatory_note

      t.timestamps
    end
  end
end
