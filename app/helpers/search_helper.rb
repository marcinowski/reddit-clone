module SearchHelper
  def save_for_search(text, table, id)
    text.gsub!(/[^a-zA-Z0-9]/, ' ')
    text.downcase!
    args = text.split(' ')
    args.each do |word|
      SearchTable.create(word: word, table: table, ref_id: id)
    end
  end

  def update_for_search(text, table, id)
    SearchTable.where(table: table, ref_id: id).destroy_all
    save_for_search(text, table, id)
  end

  def delete_from_search(table, id)
    SearchTable.where(table: table, ref_id: id).destroy_all
  end
end
