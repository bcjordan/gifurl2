class HomeController < ApplicationController
  def index
    load_index_data
  end

  # Takes in parameter :url
  def new
    # Add second slash to url that rails routing eats
    url = request.fullpath.gsub(/\/http(s?)\:/, 'http:/')

    gif = Gif.find_or_initialize_by(url: url){|g| g.remote_gif_url = url}

    if gif.new_record? && gif.save
      load_index_data
      flash.now[:success] = thumb_flash(gif, "Created gif!")
    else
      if gif.errors.include? :checksum
        found = Gif.where(checksum: gif.checksum).first
        flash.now[:notice] = thumb_flash(found, "We've got that GIF!")
      end
    end
    
    load_index_data
    render action: 'index'
  end

  # Takes in parameters :tag and optional :offset
  def jump
    candidate = Tag.find_by_id(params[:tag])
                    .gifs
                    .order_by(:score, MONGO::DESCENDING)
                    .offset(params[:offset] || 0)

    if candidate
      redirect_to candidate.gif.url
    else
      redirect_to 'http://gifurl.com'
    end
  end


  def tag_listing
    # render home page with javascript pre-set to load tag
    render 'home/index', with: {a:'b'}
  end

  def load_index_data
    @users = User.all

    @new5     = Gif.where(:title.exists => true)
                   .where(:checksum.exists => true)
                   .limit(5)
                   .only(:url, :title, :tag_ids, :gif)
                   .order_by(:_id, Mongo::DESCENDING).all

    @random10 = Gif.order_by(:views, Mongo::DESCENDING)
                   .limit(10)
                   .only(:url, :title, :tag_ids, :gif)
  end
  
  def thumb_flash(gif, message)
    image = gif.gif.thumb ? "<a href='#{gif.gif.url}'><img style='display:block;float:left;width:70px;height:70px;margin:9px 7px -1px 3px' src='#{gif.gif.thumb}'/></a>" : ''
    "#{image} <div style='margin-top:29px;float:left'>#{message}</div>".html_safe
  end
end
