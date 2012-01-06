class HomeController < ApplicationController
  def index
    @users = User.all

    @newfive = Gif.where(:title.exists => true)
                  .where(:checksum.exists => true)
                  .limit(5)
                  .only(:url, :title, :tag_ids, :gif)
                  .order_by(:_id, Mongo::DESCENDING)
  end
end
