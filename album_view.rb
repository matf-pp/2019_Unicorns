#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/photo_view'

class AlbumView <   # FXScrollWindow

  attr_reader :album

  def initialize(p, album)
    super(p, :opts => LAYOUT_FILL)
    @album = album
    FXMatrix.new(self, :opts => LAYOUT_FILL)
    @album.each_photo { |photo| add_photo(photo) }
  end

  def layout
    contentWindow.numColumns = [width/PhotoView::MAX_WIDTH, 1].max
    super
  end

  def add_photo(photo)
    PhotoView.new(contentWindow, photo)
  end

end



