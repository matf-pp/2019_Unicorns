#!/usr/bin/env ruby
# GUI za prvi CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV1 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )

    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)


    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblInfo = FXLabel.new(infoFrame, "Information:", :opts => LAYOUT_CENTER_X)
    lblInfo.textColor = Fox.FXRGB(255, 0, 5)
    lblInfo.font = FXFont.new(app, "Geneva", 12)

    # Osnovne informacije o korisniku
    info = FXHorizontalFrame.new(frame, :opts => LAYOUT_FILL_X)
    matrixInfo = FXMatrix.new(info, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblName = FXLabel.new(matrixInfo, "First and last name:  ")
    @tfName = FXTextField.new(matrixInfo, 40)

    lblAddress = FXLabel.new(matrixInfo, "Address:  ")
    @tfAddress = FXTextField.new(matrixInfo, 40)

    lblPhone = FXLabel.new(matrixInfo, "Phone number:  ")
    @tfPhone = FXTextField.new(matrixInfo, 40)

    lblMail = FXLabel.new(matrixInfo, "E-mail:  ")
    @tfMail = FXTextField.new(matrixInfo, 40)


    # Nova celina, steceno obrazovanje, eduFrame
    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblEdu = FXLabel.new(eduFrame, "Education: ", :opts => LAYOUT_CENTER_X)
    lblEdu.textColor = Fox.FXRGB(235, 85, 0)
    lblEdu.font = FXFont.new(app, "Geneva", 12)

    yearAndEduFrame = FXHorizontalFrame.new(eduFrame, :opts => PACK_UNIFORM_HEIGHT)
    @tfStartPrimarySchool = FXTextField.new(yearAndEduFrame,  6)
    lblLine = FXLabel.new(yearAndEduFrame, " - ")
    @tfEndPrimarySchool = FXTextField.new(yearAndEduFrame, 6)
    @tfEduPrimarySchool = FXTextField.new(yearAndEduFrame, 40)

    yearAndEdu1 = FXHorizontalFrame.new(eduFrame, :opts => PACK_UNIFORM_HEIGHT)
    @tfStartHighSchool = FXTextField.new(yearAndEdu1,  6)
    lblLine = FXLabel.new(yearAndEdu1, " - ")
    @tfEndHighSchool = FXTextField.new(yearAndEdu1, 6)
    @tfEduHighSchool = FXTextField.new(yearAndEdu1, 40)

    yearAndEdu2 = FXHorizontalFrame.new(eduFrame, :opts => PACK_UNIFORM_HEIGHT)
    @tfStartCollege = FXTextField.new(yearAndEdu2,  6)
    lblLine = FXLabel.new(yearAndEdu2, " - ")
    @tfEndCollege = FXTextField.new(yearAndEdu2, 6)
    @tfEduCollege = FXTextField.new(yearAndEdu2, 40)


    # Nova celina, vestine za komunikaciju
    comSkillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    @lblComSkills = FXLabel.new(comSkillsFrame, "Communication skills: ", :opts => LAYOUT_CENTER_X)
    @lblComSkills.textColor = Fox.FXRGB(45, 150, 0)
    @lblComSkills.font = FXFont.new(app, "Geneva", 12)

    comHFrame = FXHorizontalFrame.new(comSkillsFrame, :opts => LAYOUT_FILL_X)
    matrixComSkills = FXMatrix.new(comHFrame, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblNS =  FXLabel.new(matrixComSkills, "Native speaker: ")
    @tfNS = FXTextField.new(matrixComSkills, 35)

    lblGood =  FXLabel.new(matrixComSkills, "Oral and written - good: ")
    @tfGood = FXTextField.new(matrixComSkills, 35)

    lblFair =  FXLabel.new(matrixComSkills, "Oral and written - fair: ")
    @tfFair = FXTextField.new(matrixComSkills, 35)


    # Nova celina, profesionalne vestine
    profSkillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblProfSkills = FXLabel.new(profSkillsFrame, "Skills: ", :opts => LAYOUT_CENTER_X)
    lblProfSkills.textColor = Fox.FXRGB(0, 80, 150)
    lblProfSkills.font = FXFont.new(app, "Geneva", 12)

    profSkillsHFrame = FXHorizontalFrame.new(frame, :opts => LAYOUT_FILL_X)
    matrixSkills = FXMatrix.new(profSkillsHFrame, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    # TODO
    lblGoodLvl =  FXLabel.new(matrixSkills, "Good level: ")
    pomocniFrame1 = FXHorizontalFrame.new(matrixSkills, :opts => LAYOUT_FILL_X|FRAME_THICK)
    @taGoodLvl = FXText.new(pomocniFrame1, :opts => TEXT_WORDWRAP|LAYOUT_FILL_X)
    @taGoodLvl.text = ""


    lblIntermediate =  FXLabel.new(matrixSkills, "Intermediate: ")
    pomocniFrame2 = FXHorizontalFrame.new(matrixSkills, :opts => LAYOUT_FILL_X|FRAME_THICK)
    @taIntermediateLvl = FXText.new(pomocniFrame2, :opts => TEXT_WORDWRAP|LAYOUT_FILL_X)
    @taIntermediateLvl.text = ""


    lblBasicLvl =  FXLabel.new(matrixSkills, "Basic level: ")
    pomocniFrame3 = FXHorizontalFrame.new(matrixSkills, :opts => LAYOUT_FILL_X|FRAME_THICK)
    @taBasicLvl = FXText.new(pomocniFrame3,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    @taBasicLvl.width = 350
    @taBasicLvl.text = ""


    # Frame za dugmice
    btnFrame = FXHorizontalFrame.new(frame, :opts => LAYOUT_RIGHT|FRAME_THICK)


    dekor = loadIcon("plavo.png")
    @btnSubmit = FXButton.new(btnFrame,
                           "Submit",
                           dekor,
                           :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                           :width => 65, :height => 25)
    @btnSubmit.font = FXFont.new(app, "Geneva", 9)
    @btnSubmit.textColor = Fox.FXRGB(250, 250, 250)
    @btnSubmit.connect(SEL_COMMAND, method(:onSubmit))

  end

  def onSubmit(sender, sel, event)
      #TODO
      system("pdflatex main.tex")

  end

  def file_edit(filename, regexp, replacement)
    Tempfile.open(".#{File.basename(filename)}", File.dirname(filename)) do |tempfile|
      File.open(filename).each do |line|
        tempfile.puts line.gsub(regexp, replacement)
      end
      tempfile.close
      FileUtils.mv tempfile.path, filename
    end
    @mutex = Mutex.new
    @mutex.synchronize do
      retVal = system('pdflatex main.tex')
      puts(retVal)
    end
  end

  # Metod za gasenje aplikacije pomocu iksica
  def onClose(sender, sel, event)
    $app.exit(0)
  end

  # Ucitava sliku iz fajla
  def loadIcon(filename)
    filename = File.expand_path("../#{filename}", __FILE__)
    File.open(filename, "rb") do |f|
      FXPNGIcon.new(getApp(), f.read)
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

end
