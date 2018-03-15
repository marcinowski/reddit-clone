class SearchController < ApplicationController
  def index
  end

  def results
    query = params[:q]
    if (query.nil?) || (query == '')
      return redirect_to '/search'
    end
    query.downcase!
    @posts = search_posts(query)
    @subs = search_subs(query)
    @queryString = query
  end

  def results_users
    query = params[:q]
    if (query.nil?) || (query == '')
      return redirect_to '/search'
    end
    query.downcase!
    users = search_users(query)
    return render :json => users
  end

  private
  def search_users query
    results = SearchTable.order(:table).where(word: query, table: 'users').pluck(:ref_id)
    return User.where(id: results)
  end

  private
  def search_posts query
    results = SearchTable.order(:table).where(word: query, table: 'posts').pluck(:ref_id)
    return Post.where(id: results)
  end

  private
  def search_comments query
    results = SearchTable.order(:table).where(word: query, table: 'comments').pluck(:ref_id)
    return Comment.where(id: results)
  end

  private
  def search_subs query
    results = SearchTable.order(:table).where(word: query, table: 'subs').pluck(:ref_id)
    return Sub.where(id: results)
  end
end
