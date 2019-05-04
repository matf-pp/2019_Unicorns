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
    #lblInfo.textColor = Fox.FXRGB(255, 0, 5)
    lblInfo.textColor = Fox.FXRGB(120, 5, 120)
    lblInfo.font = FXFont.new(app, "Geneva", 12)

    # Osnovne informacije o korisniku
    info = FXHorizontalFrame.new(frame, :opts => LAYOUT_FILL_X)
    matrixInfo = FXMatrix.new(info, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblName = FXLabel.new(matrixInfo, "First and last name:  ")
    @tfName = FXTextField.new(matrixInfo, 39)

    lblAddress = FXLabel.new(matrixInfo, "Address:  ")
    @tfAddress = FXTextField.new(matrixInfo, 39)

    lblPhone = FXLabel.new(matrixInfo, "Phone number:  ")
    @tfPhone = FXTextField.new(matrixInfo, 39)

    lblMail = FXLabel.new(matrixInfo, "E-mail:  ")
    @tfMail = FXTextField.new(matrixInfo, 39)
    # FXHorizontalSeparator.new(info)

    # Nova celina, steceno obrazovanje, eduFrame
    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblEdu = FXLabel.new(eduFrame, "Education: ", :opts => LAYOUT_CENTER_X)
    lblEdu.textColor = Fox.FXRGB(0, 80, 150)
    lblEdu.font = FXFont.new(app, "Geneva", 12)

    yearAndEdu1 = FXHorizontalFrame.new(eduFrame, :opts => PACK_UNIFORM_HEIGHT)
    @tfStartHighSchool = FXTextField.new(yearAndEdu1,  6)
    lblLine = FXLabel.new(yearAndEdu1, " - ")
    @tfEndHighSchool = FXTextField.new(yearAndEdu1, 6)
    @tfEduHighSchool = FXTextField.new(yearAndEdu1, 39)

    yearAndEdu2 = FXHorizontalFrame.new(eduFrame, :opts => PACK_UNIFORM_HEIGHT)
    @tfStartCollege = FXTextField.new(yearAndEdu2,  6)
    lblLine = FXLabel.new(yearAndEdu2, " - ")
    @tfEndCollege = FXTextField.new(yearAndEdu2, 6)
    @tfEduCollege = FXTextField.new(yearAndEdu2, 39)


    # Nova celina, vestine za komunikaciju
    comSkillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    @lblComSkills = FXLabel.new(comSkillsFrame, "Communication skills: ", :opts => LAYOUT_CENTER_X)
    @lblComSkills.textColor = Fox.FXRGB(120, 5, 120)
    @lblComSkills.font = FXFont.new(app, "Geneva", 12)

    comHFrame = FXHorizontalFrame.new(comSkillsFrame, :opts => LAYOUT_FILL_X)
    matrixComSkills = FXMatrix.new(comHFrame, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblNS =  FXLabel.new(matrixComSkills, "Native speaker: ")
    @tfNS = FXTextField.new(matrixComSkills, 35)

    lblGood =  FXLabel.new(matrixComSkills, "Oral and written - good:  ")
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


    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X)
    expLabel = FXLabel.new(expFrame, "Work experience:", :opts => LAYOUT_FILL_X)
    expLabel.textColor = Fox.FXRGB(0, 150, 80)
    expLabel.font = FXFont.new(app, "Geneva", 12)

    expButton = FXButton.new(expFrame, "Add new row", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @expSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_FILL|MATRIX_BY_COLUMNS)
    @startYear = []
    @endYear = []
    @position = []
    @company = []
    @describe = []
    expButton.connect(SEL_COMMAND) do
      makeLayout()
      @expSpace.create
      @expSpace.recalc
    end

    # Frame za dugmice
    btnFrame = FXHorizontalFrame.new(frame, :opts => LAYOUT_RIGHT)

    dekor = loadIcon("bez1.png")
    @btnSubmit = FXButton.new(btnFrame,
                              "",
                              dekor,
                              :opts => FRAME_RAISED|LAYOUT_RIGHT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                              :width => 55, :height => 55)
    @btnSubmit.font = FXFont.new(app, "Geneva", 9)
    @btnSubmit.textColor = Fox.FXRGB(250, 250, 250)
    @btnSubmit.connect(SEL_COMMAND, method(:onSubmit))

    @choice = FXDataTarget.new(0)

  end

  def makeLayout()
    bigFrame = FXVerticalFrame.new(@expSpace, :opts => LAYOUT_FILL)
    matrica = FXMatrix.new(bigFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrica, "Period:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrica, "Position:", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrica, LAYOUT_FILL_X)
    positionFrame = FXHorizontalFrame.new(matrica, LAYOUT_FILL_X)
    @startYear.insert(-1, FXTextField.new(yearFrame,  6))

    FXLabel.new(yearFrame, " - ")
    @endYear.insert(-1, FXTextField.new(yearFrame, 6))
    @position.insert(-1, FXTextField.new(positionFrame, 45))

    FXLabel.new(bigFrame, "Company:", :opts => LAYOUT_CENTER_X)
    @company.insert(-1, FXTextField.new(bigFrame, 65, :opts=>LAYOUT_CENTER_X|TEXTFIELD_NORMAL))

    FXLabel.new(bigFrame, "Description", :opts => LAYOUT_CENTER_X)
    describeFrame = FXHorizontalFrame.new(bigFrame, :opts => LAYOUT_FILL_X|FRAME_THICK)
    @describe.insert(-1, FXText.new(describeFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @describe[-1].width = 520
  end

  def onSubmit(sender, sel, event)
      system("cp ./CV1/cv1.tex '#{@tfName}.tex'")
      file_edit("#{@tfName}.tex", 'Ime', @tfName.text)
      file_edit("#{@tfName}.tex", 'Adresa', @tfAddress.text)
      file_edit("#{@tfName}.tex", 'Telefon', @tfPhone.text)
      file_edit("#{@tfName}.tex", 'Mejl', @tfMail.text)

      file_edit("#{@tfName}.tex", 'pocetakS', @tfStartHighSchool.text)
      file_edit("#{@tfName}.tex", 'krajS', @tfEndHighSchool.text)
      file_edit("#{@tfName}.tex", 'opisS', @tfEduHighSchool.text)
      file_edit("#{@tfName}.tex", 'pocetakC', @tfStartCollege.text)
      file_edit("#{@tfName}.tex", 'krajC', @tfEndCollege.text)
      file_edit("#{@tfName}.tex", 'opisC', @tfEduCollege.text)

      file_edit("#{@tfName}.tex", 'listaJedinicaNS', @tfNS.text)
      file_edit("#{@tfName}.tex", 'listaJedinicaOG', @tfGood.text)
      file_edit("#{@tfName}.tex", 'listaJedinicaOF', @tfFair.text)

      file_edit("#{@tfName}.tex", 'dobarUTome', @taGoodLvl.text)
      file_edit("#{@tfName}.tex", 'mozeDaProdje', @taIntermediateLvl.text)
      file_edit("#{@tfName}.tex", 'ideNekako', @taBasicLvl.text)

      Catch()
      file_edit("#{@tfName}.tex", 'NestoStoTrazimo', @str1)

      system("mv '#{@tfName}.tex' CV1")

      system("pdflatex './CV1/#{@tfName}.tex'")
      system("pdflatex './CV1/#{@tfName}.tex'")

      system("mv '#{@tfName}.pdf' ~/Desktop")
      system("rm './CV1/#{@tfName}'.* ")
      system("rm '#{@tfName}'.* ")

      # Iskacuci prozorcic sa porukom
      @mess = FXMessageBox.information(self, MBOX_OK, "Done", "Your CV is ready!\nIt's waiting for you on Desktop :)")
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

  def Catch()
    @str1 = "\\section{Work experience}
            \\begin{eventlist}
                "
    @str2 = "\\item{July 2007 -- Present}
                  {eNTiDi software, Travagliato}
                  {Management and development}
            "

    @count1 = 0
    @count2 = 0
    puts @startYear.length
    while @count1 < @startYear.length
      if @startYear[@count1].text.length > 0 &&
          @endYear[@count1].text.length > 0 &&
          @describe[@count1].text.length > 0 &&
          @company[@count1].text.length > 0 &&
          @position[@count1].text.length > 0

        @str1 << " \\item{ #{@startYear[@count1]} -- #{@endYear[@count1]}}
                   {#{@company[@count1]}}
                   {#{@position[@count1]}}
                   #{@describe[@count1]} "

        @count2 += 1
      end
      @count1 += 1
    end

    @str1 << "
    \\end{eventlist}"
    if @count2 == 0
      @str1 = ""
    end

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
