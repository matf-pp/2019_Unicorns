#!/usr/bin/env ruby
require 'fox16'
include Fox
require File.dirname(__FILE__) +'/cv1'
require File.dirname(__FILE__) +'/cv4'
require File.dirname(__FILE__) + '/photo'
require File.dirname(__FILE__) + '/photo_view'
require File.dirname(__FILE__) + '/album'
require File.dirname(__FILE__) + '/album_view'


class MainWindow < FXMainWindow

  CVlist = {
      "CV1" => "cv1",
      "CV2" => "cv2",
      "CV3" => "cv3",
      "CV4" => "cv4",
      "CV5" => "cv5",
      "CV6" => "cv6",
      "CV7" => "cv7"
  }
  $mainFrame, @cVframe, @frame = nil



  def initialize()
    super($app, "CV Express", :opts => DECOR_ALL, :width => 570, :height => 600)
    $app.backColor = Fox.FXRGB(255, 255, 255)
    # Plava
    #$app.baseColor = Fox.FXRGB(176, 196, 225)
    # Lavanda
    $app.baseColor = Fox.FXRGB(238, 224, 229)

    $mainFrame = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
    @frame = FXVerticalFrame.new($mainFrame, :opts => LAYOUT_FILL)
    #celokupni okvir
    titleFrame = FXHorizontalFrame.new(@frame, LAYOUT_FILL_X)
    #okvir za "cv templates"
    title = FXLabel.new(titleFrame,"CV templates", :opts => LAYOUT_FILL_X)
    #cv templates labela, ubacena u titleFrame
    #album = FXLabel.new(@frame,"", :opts=>LAYOUT_FILL_Y)
    #postavljena labela kao "placeholder" koja ce kasnije postati album, sa slikama cv template-a
    image_frame = FXHorizontalFrame.new(@frame, LAYOUT_FILL_X|LAYOUT_FILL_Y)
    @album = Album.new("CV Templates")
    @album.add_photo(Photo.new("./slike/cv1.jpg"))
    @album.add_photo(Photo.new("./slike/cv2.jpg"))
    @album.add_photo(Photo.new("./slike/cv3.jpg"))
    @album.add_photo(Photo.new("./slike/cv4.jpg"))
    @album.add_photo(Photo.new("./slike/cv5.jpg"))
    @album.add_photo(Photo.new("./slike/cv6.jpg"))
    @album.add_photo(Photo.new("./slike/cv7.jpg"))
    @album_view = AlbumView.new(image_frame, @album)

    choseFrame = FXHorizontalFrame.new(@frame)
    #horizontalni frame za "chose template" labelu
    controls = FXHorizontalFrame.new(@frame, :opts => LAYOUT_FILL_X)
    #horizontalni frame za "next" button i odabir template-a
    exitFrame = FXHorizontalFrame.new(@frame, :opts => LAYOUT_FILL_X)
    #horizontalni frame za "exit" button

    FXLabel.new(choseFrame, "Chose template:")
    #labela "Chose template" ubacena u choseFrame
    @cvlist = FXComboBox.new(controls, 7,
                            :opts => COMBOBOX_STATIC|FRAME_SUNKEN|FRAME_THICK)
    #pravimo padajuci meni za listu cv template-a i ubacujemo ga u controls frame

    nextButton = FXButton.new(controls, " Next ",
                              :opts => BUTTON_NORMAL|LAYOUT_RIGHT)
    #postavljamo nextButton i ubacujemo ga u controlFrame, smestamo ga krajnje desno

    nextButton.connect(SEL_COMMAND, method(:onClick))

    exitButton = FXButton.new(exitFrame, "  Exit  ",
                              nil, app,FXApp::ID_QUIT,
                              :opts => BUTTON_NORMAL|LAYOUT_CENTER_X)


    @cvlist.numVisible = 7
    CVlist.keys.each do |key|
      @cvlist.appendItem(key, CVlist[key])
    end
  end

  def onClick(sender, sel, ptr)
    if(@cvlist.to_s == 'CV1')
      CV1.new().create
      self.destroy()
    elsif (@cvlist.to_s == 'CV2')
      puts("Nema jos uvek\n")
    elsif (@cvlist.to_s == 'CV3')
      puts("Takodje, nema nista\n")
    elsif (@cvlist.to_s == 'CV4')
      CV4.new().create
      self.destroy()
    elsif (@cvlist.to_s == 'CV5')
      puts("Takodje, nema nista\n")
    elsif (@cvlist.to_s == 'CV6')
      puts("Takodje, nema nista\n")
    elsif (@cvlist.to_s == 'CV7')
      puts("Takodje, nema nista\n")
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end
