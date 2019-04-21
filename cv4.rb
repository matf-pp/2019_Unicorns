#!/usr/bin/env ruby
# GUI za cetvrti CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV4 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll4 = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )

    # Osnovni frame, roditeljski
    frame4 = FXVerticalFrame.new(@scroll4, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)

  end

  # Metod za gasenje aplikacije pomocu iksica
  def onClose(sender, sel, event)
    $app.exit(0)
  end


  def create
    super
    show(PLACEMENT_SCREEN)
  end

end
