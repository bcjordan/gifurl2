class HomeController < ApplicationController
  def index
    @users = User.all

    @newfive = Gif.where(:title.exists => true)
                  .where(:url.exists => true)
                  .limit(5)
                  .only(:url, :title)
                  .order_by(:_id, Mongo::DESCENDING)
  end
end
