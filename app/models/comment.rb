require_dependency 'app/lib/searchable_model'

class Comment < ApplicationRecord
  include SearchableModel, SearchHelper

  belongs_to :user
  belongs_to :post

  after_create :save_model_for_search

  after_update :update_model_for_search

  before_destroy :destroy_model_from_search

  private
    def save_model_for_search
      save_for_search(self.content, self.class.table_name, self.id)
    end

  private
    def update_model_for_search
      update_for_search(self.content, self.class.table_name, self.id)
    end
end
