module SearchableModel
  private
    def destroy_model_from_search
      destroy_from_search(self.class.table_name, self.id)
    end
end
