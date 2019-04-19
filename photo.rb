#!/usr/bin/env ruby
class Photo

  attr_reader :path

  def initialize(path)
    @path  = path
  end
end