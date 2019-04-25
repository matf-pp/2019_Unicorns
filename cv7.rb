#!/usr/bin/env ruby
# GUI za sedmi CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV7 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )

    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)

    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y)
    infoLabel = FXLabel.new(infoFrame, "Personal info:", :opts=>LAYOUT_FILL_X | LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    infoLabel.textColor = Fox.FXRGB(0, 150, 80)
    infoLabel.font = FXFont.new(app, "Geneva", 12)
    matrica = FXMatrix.new(infoFrame, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL)
    #nameFrame = FXHorizontalFrame.new(matrica, :opts=>LAYOUT_FILL_X)
    #professionFrame = FXHorizontalFrame.new(matrica, :opts=> LAYOUT_FILL_X)
    #birthFrame = FXHorizontalFrame.new(matrica, :opts=>LAYOUT_FILL_X)
    #phoneFrame = FXHorizontalFrame.new(matrica, :opts=>LAYOUT_FILL_X)
    #mailFrame = FXHorizontalFrame.new(matrica, :opts=>LAYOUT_FILL_X)
    #siteFrame = FXHorizontalFrame.new(matrica, :opts=>LAYOUT_FILL_X)

    FXLabel.new(matrica, "First and last nema:")
    @tfName = FXTextField.new(matrica, 40)
    FXLabel.new(matrica, "Profession:")
    @tfProfession = FXTextField.new(matrica, 40)
    FXLabel.new(matrica, "Date of birth:")
    @tfBirth = FXTextField.new(matrica, 40)
    FXLabel.new(matrica, "Phone:")
    @tfPhone = FXTextField.new(matrica, 40)
    FXLabel.new(matrica, "Email:")
    @tfMail = FXTextField.new(matrica, 40)
    FXLabel.new(matrica, "Site:")
    @tfSite = FXTextField.new(matrica, 40)
    @checkMail = FXCheckButton.new(matrica, "Have a site?")
    FXHorizontalSeparator.new(infoFrame)

    aboutMeFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y)
    aboutMeLabel = FXLabel.new(aboutMeFrame, "About Me:", :opts=>LAYOUT_FILL_X | LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    aboutMeLabel.textColor = Fox.FXRGB(0, 150, 80)
    aboutMeLabel.font = FXFont.new(app, "Geneva", 12)
    helpFrame = FXHorizontalFrame.new(aboutMeFrame, :opts => LAYOUT_FILL_X|FRAME_THICK )
    @aboutMeText = FXText.new(helpFrame, :opts => TEXT_WORDWRAP|LAYOUT_FILL_X)
    @aboutMeText.text = ""
    FXHorizontalSeparator.new(aboutMeFrame)

    interestsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y)
    interestsLabel = FXLabel.new(aboutMeFrame, "Interests: ", :opts=>LAYOUT_FILL_X | LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    interestsLabel.textColor = Fox.FXRGB(0, 150, 80)
    interestsLabel.font = FXFont.new(app, "Geneva", 12)
    helpFrame = FXHorizontalFrame.new(aboutMeFrame, :opts => LAYOUT_FILL_X|FRAME_THICK )
    @interestsText = FXText.new(helpFrame, :opts => TEXT_WORDWRAP|LAYOUT_FILL_X)
    @interestsText.text = ""
    FXHorizontalSeparator.new(aboutMeFrame)

    languagesFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y)
    languagesLabel = FXLabel.new(aboutMeFrame, "Languages: ", :opts=>LAYOUT_FILL_X | LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    languagesLabel.textColor = Fox.FXRGB(0, 150, 80)
    languagesLabel.font = FXFont.new(app, "Geneva", 12)
    helpFrame = FXHorizontalFrame.new(aboutMeFrame, :opts => LAYOUT_FILL_X|FRAME_THICK )
    @languagesText = FXText.new(helpFrame, :opts => TEXT_WORDWRAP|LAYOUT_FILL_X)
    @languagesText.text = ""
    FXHorizontalSeparator.new(aboutMeFrame)

    educationFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    educationLabel = FXLabel.new(educationFrame, "Education: ", :opts=>LAYOUT_FILL_X | LAYOUT_CENTER_X)
    educationLabel.textColor = Fox.FXRGB(0,150, 80)
    educationLabel.font = FXFont.new(app, "Geneva", 12)
    @eduMatrix = FXMatrix.new(educationFrame, 3, :opts =>MATRIX_BY_COLUMNS | LAYOUT_FILL_X)
    FXLabel.new(@eduMatrix, "Period", :opts => LAYOUT_CENTER_X)
    FXLabel.new(@eduMatrix, "Description and School", :opts => LAYOUT_CENTER_X)
    FXLabel.new(@eduMatrix, "Place", :opts => LAYOUT_CENTER_X)
    eduHelper1 = FXVerticalFrame.new(@eduMatrix)
    @eduPeriod1 = FXTextField.new(eduHelper1, 10)
    eduHelper2 = FXVerticalFrame.new(@eduMatrix)
    @eduTitle1 = FXTextField.new(eduHelper2, 35)
    @eduName1 = FXTextField.new(eduHelper2, 35)
    eduHelper3 = FXVerticalFrame.new(@eduMatrix)
    @eduPlace1 = FXTextField.new(eduHelper3, 15)

    eduHelper1 = FXVerticalFrame.new(@eduMatrix)
    @eduPeriod2 = FXTextField.new(eduHelper1, 10)
    eduHelper2 = FXVerticalFrame.new(@eduMatrix)
    @eduTitle2 = FXTextField.new(eduHelper2, 35)
    @eduName2 = FXTextField.new(eduHelper2, 35)
    eduHelper3 = FXVerticalFrame.new(@eduMatrix)
    @eduPlace2 = FXTextField.new(eduHelper3, 15)

    @eduPeriod = []
    @eduTitle = []
    @eduName = []
    @eduPlace = []

    @buttonEducation = FXButton.new(educationFrame, "Add Education", :opts => LAYOUT_CENTER_X | BUTTON_NORMAL)
    @buttonEducation.connect(SEL_COMMAND) do
      makeLayoutEdu()
      @eduMatrix.create
      @eduMatrix.recalc
    end
    FXHorizontalSeparator.new(educationFrame)


    skillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    skillsLabel = FXLabel.new(educationFrame, "Skills: ", :opts=>LAYOUT_FILL_X | LAYOUT_CENTER_X)
    skillsLabel.textColor = Fox.FXRGB(0,150, 80)
    skillsLabel.font = FXFont.new(app, "Geneva", 12)
    skillsMatrix = FXMatrix.new(skillsFrame, 2, MATRIX_BY_COLUMNS)
    FXLabel.new(skillsMatrix, "Verry Good")
    @verryGood = FXTextField.new(skillsMatrix, 40)
    FXLabel.new(skillsMatrix, "Good")
    @verryGood = FXTextField.new(skillsMatrix, 40)
    FXLabel.new(skillsMatrix, "Fair")
    @verryGood = FXTextField.new(skillsMatrix, 40)
    FXHorizontalSeparator.new(skillsFrame)


    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    expLabel = FXLabel.new(expFrame, "Experience: ", :opts=>LAYOUT_FILL_X | LAYOUT_CENTER_X)
    expLabel.textColor = Fox.FXRGB(0,150, 80)
    expLabel.font = FXFont.new(app, "Geneva", 12)
    @expMatrix = FXMatrix.new(expFrame, 3, :opts =>MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    @expButton = FXButton.new(expFrame, "Add Experience", :opts => LAYOUT_CENTER_X | BUTTON_NORMAL)
    @done = false

    @expButton.connect(SEL_COMMAND) do
      if (!@done)
        FXLabel.new(@expMatrix, "Period", :opts => LAYOUT_CENTER_X)
        FXLabel.new(@expMatrix, "Description and place", :opts => LAYOUT_CENTER_X)
        FXLabel.new(@expMatrix, "Workplace", :opts => LAYOUT_CENTER_X)
        @done = true
      end

      makeLayoutExp()
      @expMatrix.create
      @expMatrix.recalc
    end

    @expName = []
    @expPlace = []
    @expPeriod = []
    @expPosition = []

    FXHorizontalSeparator.new(expFrame)

    otherFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X | LAYOUT_FILL_Y)
    otherLabel = FXLabel.new(otherFrame, "Other information: ", :opts=>LAYOUT_FILL_X | LAYOUT_FILL_Y | LAYOUT_CENTER_X)
    otherLabel.textColor = Fox.FXRGB(0, 150, 80)
    otherLabel.font = FXFont.new(app, "Geneva", 12)
    helpFrame = FXHorizontalFrame.new(otherFrame, :opts => LAYOUT_FILL_X|FRAME_THICK )
    @otherText = FXText.new(helpFrame, :opts => TEXT_WORDWRAP|LAYOUT_FILL_X)
    @otherText.text = ""
    FXHorizontalSeparator.new(otherFrame)

  end

  def makeLayoutEdu()
    eduHelper1 = FXVerticalFrame.new(@eduMatrix)
    @eduPeriod.insert(-1, FXTextField.new(eduHelper1, 10))
    eduHelper2 = FXVerticalFrame.new(@eduMatrix)
    @eduTitle.insert(-1, FXTextField.new(eduHelper2, 35))
    @eduName.insert(-1,FXTextField.new(eduHelper2, 35))
    eduHelper3 = FXVerticalFrame.new(@eduMatrix)
    @eduPlace.insert(-1, FXTextField.new(eduHelper3, 15))
  end

  def makeLayoutExp()
    expHelper1 = FXVerticalFrame.new(@expMatrix)
    @expPeriod.insert(-1, FXTextField.new(expHelper1, 10))
    expHelper2 = FXVerticalFrame.new(@expMatrix)
    @expPosition.insert(-1, FXTextField.new(expHelper2, 35))
    @expName.insert(-1, FXTextField.new(expHelper2, 35))
    expHelper3 = FXVerticalFrame.new(@expMatrix)
    @expPlace.insert(-1, FXTextField.new(expHelper3, 15))

  end

  # Projekti, polja
  def makeLayoutApp()

  end

  def onSubmit(sender, sel, event)

  end

  def file_edit(filename, regexp, replacement)
    @mutex = Mutex.new
    @mutex.synchronize do
      Tempfile.open(".#{File.basename(filename)}", File.dirname(filename)) do |tempfile|
        File.open(filename).each do |line|
          tempfile.puts line.gsub(regexp, replacement)
        end
        tempfile.close
        FileUtils.mv tempfile.path, filename
      end

    end
  end

  def Catch1()

  end

  def Catch2()
  end

  # Metod za gasenje aplikacije pomocu iksica
  def onClose(sender, sel, event)
    $app.exit(0)
  end

  # Ucitava sliku iz fajla
  def loadIcon(filename)
    filename = File.expand_path("../slike/#{filename}", __FILE__)
    File.open(filename, "rb") do |f|
      FXPNGIcon.new(getApp(), f.read)
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

end

