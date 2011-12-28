class Tag
  include Mongoid::Document
  field :name
  has_and_belongs_to_many :gifs
  accepts_nested_attributes_for :gifs
  key :name

  def best
    # Or memcached
    @best ||= gifs.driver.find({sort: [[ :upvotes, :desc ]]}).first
  end
end