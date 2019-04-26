#!/usr/bin/env ruby
# GUI za sedmi CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV6 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )

    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)

    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    infoLabel = FXLabel.new(infoFrame, "Personal Info: ", :opts => LAYOUT_FILL_X | LAYOUT_CENTER_X)
    infoLabel.textColor = Fox.FXRGB(233, 30, 90)
    infoLabel.font = FXFont.new(app, "Geneva", 12)
    infoMatrix = FXMatrix.new(infoFrame, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL)
    FXLabel.new(infoMatrix, "First and last name: ")
    @nameText = FXTextField.new(infoMatrix, 35)
    FXLabel.new(infoMatrix, "Adress")
    @adressText = FXTextField.new(infoMatrix, 35)
    FXLabel.new(infoMatrix, "Profession: ")
    @professionText = FXTextField.new(infoMatrix, 35)
    FXLabel.new(infoMatrix, "Email: ")
    @emailText = FXTextField.new(infoMatrix, 35)
    FXLabel.new(infoMatrix, "Phone: ")
    @phoneText = FXTextField.new(infoMatrix, 35)

    FXHorizontalSeparator.new(infoFrame)

    addFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    addLabel = FXLabel.new(addFrame, "Additional Info: ", :opts => LAYOUT_FILL_X | LAYOUT_CENTER_X)
    addLabel.textColor = Fox.FXRGB(233, 30, 90)
    addLabel.font = FXFont.new(app, "Geneva", 12)
    addMatrix = FXMatrix.new(addFrame, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL)
    FXLabel.new(addMatrix, "Status: ")
    @statusText = FXTextField.new(addMatrix, 35)
    FXLabel.new(addMatrix, "Skills")
    @skillsText = FXTextField.new(addMatrix, 35)
    FXLabel.new(addMatrix, "Languages:              ")
    @languagesText = FXTextField.new(addMatrix, 35)
    FXLabel.new(addMatrix, "Hobies: ")
    @hobieText = FXTextField.new(addMatrix, 35)

    FXHorizontalSeparator.new(addFrame)

    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    eduLabel = FXLabel.new(eduFrame, "Education: ", :opts=> LAYOUT_FILL_X|LAYOUT_CENTER_X)
    eduLabel.textColor = Fox.FXRGB(233, 30, 90)
    eduLabel.font = FXFont.new(app, "Geneva", 12)
    @institutionText = []
    @periodText = []
    @avgGradeText = []
    @descrioptionText = []
    @schoolDegreeText = []

    @eduMatrix = FXMatrix.new(eduFrame, 2, :opts => MATRIX_BY_COLUMNS)
    FXLabel.new(@eduMatrix, "Period")
    @periodText.insert(-1, FXTextField.new(@eduMatrix, 15))
    FXLabel.new(@eduMatrix, "Name")
    @schoolDegreeText.insert(-1, FXTextField.new(@eduMatrix, 35))
    FXLabel.new(@eduMatrix, "Institution")
    @institutionText.insert(-1, FXTextField.new(@eduMatrix, 35))
    FXLabel.new(@eduMatrix, "Description")
    @descrioptionText.insert(-1, FXTextField.new(@eduMatrix, 35))
    FXLabel.new(@eduMatrix, "Average grade         ")
    @avgGradeText.insert(-1, FXTextField.new(@eduMatrix, 10))

    @eduButton = FXButton.new(eduFrame, "Add education", :opts=>LAYOUT_LEFT| BUTTON_NORMAL)
    FXHorizontalSeparator.new(eduFrame)
    @eduButton.connect(SEL_COMMAND) do
      makeLayoutEdu()
      @eduMatrix.create
      @eduMatrix.recalc
    end



  end

  def makeLayoutEdu()
    FXLabel.new(@eduMatrix, "")
    FXLabel.new(@eduMatrix, "")
    FXLabel.new(@eduMatrix, "Period")
    @periodText.insert(-1, FXTextField.new(@eduMatrix, 15))
    FXLabel.new(@eduMatrix, "Name")
    @schoolDegreeText.insert(-1, FXTextField.new(@eduMatrix, 35))
    FXLabel.new(@eduMatrix, "Institution")
    @institutionText.insert(-1, FXTextField.new(@eduMatrix, 35))
    FXLabel.new(@eduMatrix, "Description")
    @descrioptionText.insert(-1, FXTextField.new(@eduMatrix, 35))
    FXLabel.new(@eduMatrix, "Average grade         ")
    @avgGradeText.insert(-1, FXTextField.new(@eduMatrix, 10))
  end

  def makeLayoutExp()


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

