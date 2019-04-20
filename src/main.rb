#!/usr/bin/env ruby
require 'fox16'
require File.dirname(__FILE__) + '/main_window'
include Fox

if __FILE__ == $0
  $app = FXApp.new
  MainWindow.new()
  $app.create
  $app.run
end
