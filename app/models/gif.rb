class Gif
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  has_and_belongs_to_many :tags, index: true
  has_and_belongs_to_many :users

  # TODO: cache multi-tagging count in Gif model (for popularity/confidence)
  # field :taggings, type: Hash, default: {} # {tagname: count, tagname: count}

  field :views, default: 0
  field :upvotes, default: 0
  field :downvotes, default: 0
  field :url
  field :title
  field :score, default: 0

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
end
