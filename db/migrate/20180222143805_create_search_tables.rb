class CreateSearchTables < ActiveRecord::Migration[5.1]
  def change
    create_table :search_tables do |t|
      t.string :word
      t.string :table
      t.integer :ref_id

      t.timestamps
    end
    add_index :search_tables, :word
  end
end
