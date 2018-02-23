class AddIndexToSearchTable < ActiveRecord::Migration[5.1]
  def change
    add_index :search_tables, [:word, :table, :ref_id]
  end
end
