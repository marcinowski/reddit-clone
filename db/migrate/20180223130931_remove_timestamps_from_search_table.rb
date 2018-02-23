class RemoveTimestampsFromSearchTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :search_tables, :created_at, :string
    remove_column :search_tables, :updated_at, :string
  end
end
