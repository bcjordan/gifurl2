require 'spec_helper'

describe Gif, "#tag" do
  before(:each) do
    @gif = Gif.create!()
  end

  it "should add and return tags" do
    20.times { |n| @gif.tag("tag#{n}") }

    @gif.tags.size.should == 20

    20.times { |n| @gif.tag_ids.count("tag#{n}").should == 1 }
  end

  it "should add URLs" do
    20.times { |n| @gif.add_url "http://google.com/#{n}" }

    # Store most recent url
    @gif.url.include?("google").should == true
    @gif.urls.size.should == 20
  end

  it "should take up and down votes" do
    @gif.upvotes.should == 0
    @gif.upvote
    @gif.upvotes.should == 1
  end

  it "should untag" do
    @gif.tag('a').tag('b').tag('c')
    Tag.where(name: 'a').size.should == 1
    Tag.where(name: 'a').first.gif_ids.include?(@gif._id).should == true
    @gif.untag('a')
    Tag.where(name: 'a').first.gif_ids.include?(@gif._id).should == false
  end

  it "should take a list of separated tags" do
    @gif.tag('q')
    
    @gif.tag('a b c d e f g', ' ')

    @gif.tag_ids.size.should == 8
  end

  it "should not store duplicate tags" do
    @gif.tag('a')
    @gif.tag('a')

    @gif.tag_ids.size.should == 1
  end

  after(:each) do
    @gif.destroy
  end
end


describe Tag do
  TAG_NAME = 'popcorn'
  
  before(:each) do
    # gifs tagged with [TAG_NAME, tagNN]
    30.times { |n| Gif.create!().tag(TAG_NAME).tag("tag#{n}") }
  end

  it "should find gifs for #{TAG_NAME}" do
    tag  = Tag.find(TAG_NAME)
    gifs = tag.gifs

    gifs.size.should == 30
  end

  #it "should return most upvoted gif with tag" do
  #  upvoting = Gif.last
  #  upvoting.upvote
  #  upvoting.upvote
  #
  #  top = Tag.find(TAG_NAME).best
  #
  #  top.should == upvoting
  #end

  after(:each) do
    Gif.destroy_all
  end
end

describe Url do
  before(:each) do
    @gif  = Gif.create!()
    @urls = 5.times.map{|n| "http://google.com/#{n}.gif"}
  end

  it "should add urls, keeping most recent" do
    @urls.each{|url| @gif.add_url url}

    @gif.urls.each{|url| @urls.include?(url.url).should == true}
  end
  
  after(:each) do
    @gif.destroy
  end
end