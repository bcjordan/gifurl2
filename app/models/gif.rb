class Gif
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :tags, index: true
  has_and_belongs_to_many :users

  before_validation :update_gif_attributes

  validates_uniqueness_of :checksum

  # TODO: cache multi-tagging count in Gif model (for popularity/confidence)
  # field :taggings, type: Hash, default: {} # {tagname: count, tagname: count}

  # TODO: cache uploaded file size, dimensions, content type
  # https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Store-the-uploaded-file-size-and-content-type

  field :views, default: 0
  field :upvotes, default: 0
  field :downvotes, default: 0
  field :url
  field :title
  field :score, default: 0
  field :checksum
  field :md5
  field :content_type
  field :file_size

  field :gif
  mount_uploader :gif, GifUploader

  field :url_hash, default: -> { Gif.free_hash }
  validates_presence_of :url_hash
  index :url_hash

  embeds_many :urls

  # Setters
  def add_url(url)
    self.url = url
    urls.create(url: url)
  end

  # Ensures this gif is tagged with certain tag strings
  # Takes in an optional separator as a second argument
  def tag(tag_name, *args)
    tag_names = tag_name.split(args.first)

    tag_names.each do |tag_name|
      if !(self.tag_ids.include?(tag_name))
        tags << Tag.find_or_create_by(name: tag_name)
      end
    end
    self
  end

  def untag(tag_name)
    tags.delete(Tag.find(tag_name))
    tags.where(name: tag_name).destroy_all
    self
  end

  def view()     inc(:views,     1); inc(:score, 1); self end
  def upvote()   inc(:upvotes,   1); inc(:score, 1); self end
  def downvote() inc(:downvotes, 1); inc(:score, -1); self end

  def self.free_hash
    img_hash = '-'
    while(img_hash.match(/-|_/) || Gif.exists?(conditions: {url_hash: img_hash}))
      img_hash = SecureRandom.urlsafe_base64(4).chop
    end
    img_hash
  end

  private
  
  def update_gif_attributes
    if gif.present? && !self.checksum
      self.content_type = gif.file.content_type
      self.file_size = gif.file.size
      self.md5 = gif.md5
      self.checksum = gif.checksum
    end
  end

end
