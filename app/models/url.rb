class Url
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url
  field :clean

  embedded_in :post
end