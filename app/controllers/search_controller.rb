class SearchController < ApplicationController
  def index
  end

  def results
    @queryString = params[:q].downcase
    if params[:q].nil?
      redirect_to '/search'
    end
    results = SearchTable.order(:table).where(word: @queryString)
    objects = {}
    results.each do |o|
      if objects[o.table].nil?
        objects[o.table] = []
      end
      objects[o.table].push(o.ref_id)
    end
    @posts = Post.where(id: objects['posts'])
    @comments = Comment.where(id: objects['comments'])
    @users = User.where(id: objects['users'])
  end
end
