#!/usr/bin/env ruby
class Album

  attr_reader :title

  def initialize(title)
    @title = title
    @photos = []
  end

  def add_photo(photo)
    @photos << photo
  end

  def each_photo
    @photos.each { |photo| yield photo }
  end
end