#!/usr/bin/env ruby
# GUI za sesti CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV6 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )

    @picPath = ""

    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)

    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
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

    addFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
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

    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
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

    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    expLabel = FXLabel.new(expFrame, "Experience: ", :opts=> LAYOUT_FILL_X|LAYOUT_CENTER_X)
    expLabel.textColor = Fox.FXRGB(233, 30, 90)
    expLabel.font = FXFont.new(app, "Geneva", 12)
    @institutionTextExp = []
    @periodTextExp = []
    @avgGradeTextExp = []
    @descrioptionTextExp = []
    @schoolDegreeTextExp = []
    @expDone = false
    @expMatrix = FXMatrix.new(expFrame, 2, :opts => MATRIX_BY_COLUMNS)

    @expButton = FXButton.new(expFrame, "Add experience", :opts=>LAYOUT_LEFT| BUTTON_NORMAL)
    FXHorizontalSeparator.new(expFrame)
    @expButton.connect(SEL_COMMAND) do
      makeLayoutExp()
      @expMatrix.create
      @expMatrix.recalc
    end


    buttonFrame = FXHorizontalFrame.new(frame, :opts=>LAYOUT_CENTER_X)
    dekoracija  = loadIcon("drugi.png")
    @picButton = FXButton.new(buttonFrame, "",
                              dekoracija,
                              :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                              :width => 55, :height => 55)
    @picButton.connect(SEL_COMMAND) do
      dialog = FXFileDialog.new(self, "Open JPEG File")
      dialog.patternList = [
          "JPEG Files (*.jpg, *.jpeg)"
      ]
      dialog.selectMode = SELECTFILE_EXISTING
      if dialog.execute != 0
        openJpgFile(dialog.filename)
      end
    end

    dekor = loadIcon("bez1.png")
    @btnSubmit = FXButton.new(buttonFrame,
                              "",
                              dekor,
                              :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                              :width => 55, :height => 55)
    @btnSubmit.font = FXFont.new(app, "Geneva", 9)
    @btnSubmit.textColor = Fox.FXRGB(250, 250, 250)
    @btnSubmit.connect(SEL_COMMAND, method(:onSubmit))



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
    FXLabel.new(@expMatrix, "")
    FXLabel.new(@expMatrix, "")
    FXLabel.new(@expMatrix, "Period")
    @periodTextExp.insert(-1, FXTextField.new(@expMatrix, 15))
    FXLabel.new(@expMatrix, "Position")
    @schoolDegreeTextExp.insert(-1, FXTextField.new(@expMatrix, 35))
    FXLabel.new(@expMatrix, "Institution")
    @institutionTextExp.insert(-1, FXTextField.new(@expMatrix, 35))
    FXLabel.new(@expMatrix, "Description                ")
    @descrioptionTextExp.insert(-1, FXTextField.new(@expMatrix, 35))
    FXLabel.new(@expMatrix, "Jobs")
    @avgGradeTextExp.insert(-1, FXTextField.new(@expMatrix, 10))
  end

  def openJpgFile(filename)
    @picPath = "#{filename}"
  end

  # Projekti, polja


  def onSubmit(sender, sel, event)

    system("cp ./CV6/cv6.tex '#{@nameText}.tex'")
    @expString = ""
    @schoolString = ""
    file_edit("#{@nameText}.tex", 'Profesn', @professionText.text)
    file_edit("#{@nameText}.tex", 'AdreSSa', @adressText.text)
    file_edit("#{@nameText}.tex", 'mejl', @emailText.text)
    file_edit("#{@nameText}.tex", 'telefon', @phoneText.text)

    file_edit("#{@nameText}.tex", 'ImePrezime', @nameText.text)

    file_edit("#{@nameText}.tex", 'statusLista', @statusText.text)
    file_edit("#{@nameText}.tex", 'sklsLista', @skillsText.text)
    file_edit("#{@nameText}.tex", 'langsLista', @languagesText.text)
    file_edit("#{@nameText}.tex", 'hobiesLista', @hobieText.text)


    file_edit("#{@nameText}.tex", 'hajSkulNejm', @schoolDegreeText[0].text)
    file_edit("#{@nameText}.tex", 'hajSkulInstitution', @institutionText[0].text)
    file_edit("#{@nameText}.tex", 'hajSkulPeriod', @periodText[0].text)
    file_edit("#{@nameText}.tex", 'avgOcenaSkul', @avgGradeText[0].text)
    file_edit("#{@nameText}.tex", 'deskrajbSkul', @descrioptionText[0].text)

    catchEdu()

    catchExp()

    file_edit("#{@nameText}.tex", 'EdukejsnLista', @expString)
    file_edit("#{@nameText}.tex", 'SkulLista', @schoolString)

    @picPath = @picPath.gsub(/\.jpg|\.jpeg/, '')

    file_edit("#{@nameText}.tex", 'pokusajSlike', @picPath)


    system("mv '#{@nameText}.tex' CV6")

    system("pdflatex './CV6/#{@nameText}.tex'")
    system("pdflatex './CV6/#{@nameText}.tex'")

    system("mv '#{@nameText}.pdf' ~/Desktop")
    system("rm './CV6/#{@nameText}'.* ")
    system("rm '#{@nameText}'.* ")

    # Iskacuci prozorcic sa porukom
    @mess = FXMessageBox.information(self, MBOX_OK, "Done", "Your CV is ready!\n")
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

  def catchEdu()

    if(@institutionText.size > 1)
      i = 1
      while(i < @institutionText.size) do
        @schoolString << "\n \\cvevent{#{@periodText[i].text}}{#{@schoolDegreeText[i].text}}{#{@institutionText[i].text}}{#{@descrioptionText[i].text}}{#{@avgGradeText[i].text}}"
        i+=1
      end
    end
    end

  def catchExp()

    if(@institutionText.size > 0)
      i = 0
      while(i < @institutionTextExp.size) do
        @expString << "\n \\cvevent{#{@periodTextExp[i].text}}{#{@schoolDegreeTextExp[i].text}}{#{@institutionTextExp[i].text}}{#{@descrioptionTextExp[i].text}}{#{@avgGradeTextExp[i].text}}"
        i+=1
      end
    end
  end

  # Metod za gasenje aplikacije pomocu iksica
  def onClose(sender, sel, event)
    $app.exit(0)
  end

  # Ucitava sliku iz fajla
  def loadIcon(filename)
    filename = File.expand_path("../images/#{filename}", __FILE__)
    File.open(filename, "rb") do |f|
      FXPNGIcon.new(getApp(), f.read)
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

end

