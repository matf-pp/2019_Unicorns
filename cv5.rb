#!/usr/bin/env ruby
# GUI za peti CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV5 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )
    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)
    @picturePath = ""

    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblInfo = FXLabel.new(infoFrame, "About:", :opts => LAYOUT_CENTER_X)
    lblInfo.textColor = Fox.FXRGB(30, 75, 210)
    lblInfo.font = FXFont.new(app, "Geneva", 12)

    info = FXHorizontalFrame.new(infoFrame, :opts => LAYOUT_CENTER_X)
    matrixInfo = FXMatrix.new(info, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblName = FXLabel.new(matrixInfo, "First name:  ")
    @tfName = FXTextField.new(matrixInfo, 30)
    lblLastName = FXLabel.new(matrixInfo, "Last name:  ")
    @tfLastName = FXTextField.new(matrixInfo, 30)
    lblDateOfBirth = FXLabel.new(matrixInfo, "Date of Birth: ")
    @tfDateOfBirth = FXTextField.new(matrixInfo, 30)

    lblAddress = FXLabel.new(matrixInfo, "Address:  ")
    @tfAddress = FXTextField.new(matrixInfo, 30)
    lblPhone = FXLabel.new(matrixInfo, "Phone: ")
    @tfPhone = FXTextField.new(matrixInfo, 30)
    lblMail = FXLabel.new(matrixInfo, "E-mail:  ")
    @tfMail = FXTextField.new(matrixInfo, 30)

    FXHorizontalSeparator.new(infoFrame)

    # Nova celina, obrazovanje
    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblEdu = FXLabel.new(eduFrame, "Education:", :opts => LAYOUT_CENTER_X)
    lblEdu.textColor = Fox.FXRGB(30, 75, 210)
    lblEdu.font = FXFont.new(app, "Geneva", 12)

    btnEdu = FXButton.new(eduFrame, "Add fields", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @eduSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @startYear = []
    @endYear = []
    @eduLvl = []
    @desc = []
    btnEdu.connect(SEL_COMMAND) do
      makeLayoutEdu()
      @eduSpace.create
      @eduSpace.recalc
    end

    # Nova celina, radno iskustvo
    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X)
    lblExp = FXLabel.new(expFrame, "Experience:", :opts => LAYOUT_FILL_X)
    lblExp.textColor = Fox.FXRGB(30, 75, 210)
    lblExp.font = FXFont.new(app, "Geneva", 12)

    btnExp = FXButton.new(expFrame, "Add fields", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @expSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @start = []
    # @end = []
    @position = []
    @company = []
    btnExp.connect(SEL_COMMAND) do
      makeLayoutExp()
      @expSpace.create
      @expSpace.recalc
    end

    # Nova celina, projekti / volontiranja
    projFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblProj = FXLabel.new(projFrame, "Volunteer work / projects:", :opts => LAYOUT_CENTER_X)
    lblProj.textColor = Fox.FXRGB(30, 75, 210)
    lblProj.font = FXFont.new(app, "Geneva", 12)

    btnProj = FXButton.new(projFrame, "Add fields", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @projSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @yearS = []
    @name = []
    @description = []
    btnProj.connect(SEL_COMMAND) do
      makeLayoutProj()
      @projSpace.create
      @projSpace.recalc
    end

    # Nova celina, profesionalne i licne vestine
    skillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblSkills = FXLabel.new(skillsFrame, "Skills and Background Knowledge ", :opts => LAYOUT_CENTER_X)
    lblSkills.textColor = Fox.FXRGB(30, 75, 210)
    lblSkills.font = FXFont.new(app, "Geneva", 12)

    tmpFrame1 = FXHorizontalFrame.new(skillsFrame, :opts => LAYOUT_CENTER_X)
    lblTech = FXLabel.new(tmpFrame1, "Technical skills: ", :opts => LAYOUT_FILL_X)
    lblTech.textColor = Fox.FXRGB(195, 5, 180)
    lblTech.font = FXFont.new(app, "Geneva", 10)
    btnTechnical = FXButton.new(tmpFrame1, "Add technical skill", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @techSpace = FXMatrix.new(skillsFrame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @skills = []
    @level = []
    btnTechnical.connect(SEL_COMMAND) do
      makeLayoutTech()
      @techSpace.create
      @techSpace.recalc
    end

    tmpFrame2 = FXHorizontalFrame.new(skillsFrame, :opts => LAYOUT_CENTER_X)
    lblPers = FXLabel.new(tmpFrame2, "Personal skills: ", :opts => LAYOUT_FILL_X)
    lblPers.textColor = Fox.FXRGB(195, 5, 180)
    lblPers.font = FXFont.new(app, "Geneva", 10)
    btnPersonal = FXButton.new(tmpFrame2, "Add personal skill", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @persSpace = FXMatrix.new(skillsFrame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @persSkills = []
    btnPersonal.connect(SEL_COMMAND) do
      makeLayoutPers()
      @persSpace.create
      @persSpace.recalc
    end

    # Nova celina, komunikacione vestine
    comFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblLang = FXLabel.new(comFrame, "Languages: ", :opts => LAYOUT_FILL_X)
    lblLang.textColor = Fox.FXRGB(30, 75, 210)
    lblLang.font = FXFont.new(app, "Geneva", 12)
    btnLanguage = FXButton.new(comFrame, "Add a language", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @langSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @languages = []
    @lvl = []
    btnLanguage.connect(SEL_COMMAND) do
      makeLayoutLang()
      @langSpace.create
      @langSpace.recalc
    end

    @choice = FXDataTarget.new(0)
    @radio = []
    groupbox = FXGroupBox.new(frame, "Color:", :opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    @radio.insert(-1, FXRadioButton.new(groupbox, "blue",
                                        :target => @choice, :selector => FXDataTarget::ID_OPTION))
    @radio.insert(-1, FXRadioButton.new(groupbox, "orange",
                                        :target => @choice, :selector => FXDataTarget::ID_OPTION+1))
    @radio.insert(-1, FXRadioButton.new(groupbox, "green",
                                        :target => @choice, :selector => FXDataTarget::ID_OPTION+2))
    @radio.insert(-1, FXRadioButton.new(groupbox, "red",
                                        :target => @choice, :selector => FXDataTarget::ID_OPTION+3))
    @radio.insert(-1, FXRadioButton.new(groupbox, "purple",
                                        :target => @choice, :selector => FXDataTarget::ID_OPTION+4))
    @radio.insert(-1, FXRadioButton.new(groupbox, "grey",
                                        :target => @choice, :selector => FXDataTarget::ID_OPTION+5))
    @radio.insert(-1, FXRadioButton.new(groupbox, "black",
                                        :target => @choice, :selector => FXDataTarget::ID_OPTION+6))

    # Nova celina, dugmici
    btnFrame = FXHorizontalFrame.new(frame, :opts => LAYOUT_RIGHT)

    dekoracija  = loadIcon("drugi.png")
    @btnPicture = FXButton.new(btnFrame, "",
                               dekoracija,
                               :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                               :width => 55, :height => 55)
    @btnPicture.connect(SEL_COMMAND) do
      dialog = FXFileDialog.new(self, "Choose picture")
      dialog.patternList = [
          "JPEG Files (*.jpg, *.jpeg)",
      ]
      dialog.selectMode = SELECTFILE_EXISTING
      if dialog.execute != 0
        openJpgFile(dialog.filename)
      end
    end

    dekor = loadIcon("bez1.png")
    @btnSubmit = FXButton.new(btnFrame,
                              "",
                              dekor,
                              :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT,
                              :width => 55, :height => 55)
    @btnSubmit.font = FXFont.new(app, "Geneva", 9)
    @btnSubmit.textColor = Fox.FXRGB(250, 250, 250)
    @btnSubmit.connect(SEL_COMMAND, method(:onSubmit))

  end

  # Radno iskustvo, polja
  def makeLayoutExp()
    parentFrame = FXVerticalFrame.new(@expSpace, :opts => LAYOUT_FILL)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Period:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Position:", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    positionFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    @start.insert(-1, FXTextField.new(yearFrame,  12))

    #FXLabel.new(yearFrame, " - ")
    #@end.insert(-1, FXTextField.new(yearFrame, 5))
    @position.insert(-1, FXTextField.new(positionFrame, 38))

    FXLabel.new(parentFrame, "Company:", :opts => LAYOUT_CENTER_X)
    descFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_CENTER_X)
    @company.insert(-1, FXTextField.new(descFrame,  52))
    @company[-1].width = 450

    FXHorizontalSeparator.new(parentFrame)
  end

  # Obrazovanje, polja
  def makeLayoutEdu()
    parentFrame = FXVerticalFrame.new(@eduSpace, :opts => LAYOUT_CENTER_X)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Period:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Studies: ", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrix, LAYOUT_CENTER_X)
    eduLvlFrame = FXHorizontalFrame.new(matrix, LAYOUT_CENTER_X)
    @startYear.insert(-1, FXTextField.new(yearFrame,  5))

    FXLabel.new(yearFrame, " - ")
    @endYear.insert(-1, FXTextField.new(yearFrame, 5))
    @eduLvl.insert(-1, FXTextField.new(eduLvlFrame, 38))

    FXLabel.new(parentFrame, "Description: ", :opts => LAYOUT_CENTER_X)
    descFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @desc.insert(-1, FXText.new(descFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @desc[-1].width = 450

    FXHorizontalSeparator.new(parentFrame)
  end

  #Projekti, volontiranja, polja
  def makeLayoutProj()
    parentFrame = FXVerticalFrame.new(@projSpace, :opts => LAYOUT_CENTER_X)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Year:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Volunteer work / projects : ", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrix, LAYOUT_CENTER_X)
    nameFrame = FXHorizontalFrame.new(matrix, LAYOUT_CENTER_X)
    @yearS.insert(-1, FXTextField.new(yearFrame,  5))

    @name.insert(-1, FXTextField.new(nameFrame, 45))

    FXLabel.new(parentFrame, "Description: ", :opts => LAYOUT_CENTER_X)
    descFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @description.insert(-1, FXText.new(descFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @description[-1].width = 450

    FXHorizontalSeparator.new(parentFrame)
  end

  # profesionalne vestine, polja
  def makeLayoutTech()
    parentFrame = FXVerticalFrame.new(@techSpace, :opts => LAYOUT_FILL)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Skill:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Level:", :opts=> LAYOUT_CENTER_X)

    skFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    lvlFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    @skills.insert(-1, FXTextField.new(skFrame,  25))
    @level.insert(-1, FXTextField.new(lvlFrame, 25))

    FXHorizontalSeparator.new(parentFrame)
  end

  # licne osobine, polja
  def makeLayoutPers()
    parentFrame = FXVerticalFrame.new(@persSpace, :opts => LAYOUT_FILL)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Description:", :opts => LAYOUT_CENTER_X)
    skFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    @persSkills.insert(-1, FXTextField.new(skFrame,  35))

    FXHorizontalSeparator.new(parentFrame)
  end

  # Jezici, polja
  def makeLayoutLang()
    parentFrame = FXVerticalFrame.new(@langSpace, :opts => LAYOUT_FILL)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Language:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Level:", :opts=> LAYOUT_CENTER_X)

    lFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    lvlFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    @languages.insert(-1, FXTextField.new(lFrame,  25))
    @lvl.insert(-1, FXTextField.new(lvlFrame, 25))

    FXHorizontalSeparator.new(parentFrame)
  end


  def onSubmit(sender, sel, event)
    system("cp ./CV5/cv5.tex '#{@tfName}.tex'")

    file_edit("#{@tfName}.tex", 'Ime', @tfName.text)
    file_edit("#{@tfName}.tex", 'Prezime', @tfLastName.text)
    file_edit("#{@tfName}.tex", 'datum', @tfDateOfBirth.text)
    file_edit("#{@tfName}.tex", 'brojTelefona', @tfPhone.text)
    file_edit("#{@tfName}.tex", 'mejl', @tfMail.text)
    file_edit("#{@tfName}.tex", 'Adresa', @tfAddress.text)

    # Fja koja obradjuje uneto iskustvo
    CatchExp()
    file_edit("#{@tfName}.tex", 'RadnoIskustvoKorisnika', @str1)
    # Fja koja obradjuje uneto obrazovanje
    CatchEdu()
    file_edit("#{@tfName}.tex", 'ObrazovanjeKorisnika', @str2)

    CatchProj()
    file_edit("#{@tfName}.tex", 'volonterskiRadIliProjekat', @str3)

    CatchTech()
    file_edit("#{@tfName}.tex", 'profVestina', @str4)

    CatchPers()
    file_edit("#{@tfName}.tex", 'licneOsobine', @str5)

    CatchLang()
    file_edit("#{@tfName}.tex", 'jezici', @str6)

    file_edit("#{@tfName}.tex", 'boja', @radio[@choice.value].text)

    if(@picturePath.length == 0)
      @picturePath = "./images/white.jpg"
    end

    @picturePath = @picturePath.gsub(/\.jpg|\.jpeg/, '')

    file_edit("#{@tfName}.tex", 'slika', @picturePath)

    system("pdflatex '#{@tfName}.tex'")
    system("pdflatex '#{@tfName}.tex'")

    system("mv '#{@tfName}.pdf' ~/Desktop")
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

  # Obrada radnog iskustva
  def CatchExp()
    @str1 = "\\section{Work Experience}
            "
    @count1 = 0
    @count2 = 0

    while @count1 < @start.length
      if @start[@count1].text.length > 0 &&
          @position[@count1].text.length > 0 &&
          @company[@count1].text.length > 0
        @str1 << "\\cvitem{#{@start[@count1]}}{\\textbf{#{@position[@count1]}} \\textit{#{@company[@count1]}} }
                \\renewcommand{\\listitemsymbol}{\\textcolor{black}{-~}}
                "
        @count2 += 1
      end
      @count1 += 1
    end

    if @count2 == 0
      @str1 = ""
    end
  end

  # Obrada obrazovanja
  def CatchEdu()
    @str2 = "\\section{Education}
            "
    @count3 = 0
    @count4 = 0

    while @count3 < @startYear.length
      if @startYear[@count3].text.length > 0 &&
          @endYear[@count3].text.length > 0 &&
          @eduLvl[@count3].text.length > 0 &&
          @desc[@count3].text.length > 0
        @str2 << "\\cvitem{#{@startYear[@count3]} -- #{@endYear[@count3]}}{\\textbf{#{@eduLvl[@count3]} } \\textit{}
                  \\newline #{@desc[@count3]}}
                 "
        @count4 += 1
      end
      @count3 += 1
    end
    if @count4 == 0
      @str2 = ""
    end
  end

  # Obrada projekata i volontiranja
  def CatchProj()
    @str3 = "\\section{Acheived Projects or volunteer work}
            "
    @count5 = 0
    @count6 = 0

    while @count5 < @yearS.length
      if @yearS[@count5].text.length > 0 &&
          @name[@count5].text.length > 0 &&
          @description[@count5].text.length > 0
        @str3 << "\\cvitem{#{@yearS[@count5]}}{\\textbf{#{@name[@count5]}} \\textit{} \\newline #{@description[@count5]}}
                 "
        @count6 += 1
      end
      @count5 += 1
    end
    if @count6 == 0
      @str3 = ""
    end
  end

  # Obrada vestina
  def CatchTech()
    @str4 = "\\subsection{Technical skills}
            "
    @count7 = 0
    @count8 = 0
    while @count7 < @skills.length
      if @skills[@count7].text.length > 0 &&
          @level[@count7].text.length > 0
        @str4 << "\\cvitem{}{#{@skills[@count7]}, \\textit{#{@level[@count7]}}}
                 "
        @count8 += 1
      end
      @count7 += 1
    end
    if @count8 == 0
      @str4 = ""
    end
  end

  # Obrada osobina
  def CatchPers()
    @str5 = "\\subsection{Personal skills}
            "
    @count9 = 0
    @count10 = 0

    while @count9 < @persSkills.length
      if @persSkills[@count9].text.length > 0
        @str5 << "\\cvitem{}{#{@persSkills[@count9]}}
                 "
        @count10 += 1
      end
      @count9 += 1
    end
    if @count10 == 0
      @str5 = ""
    end
  end

  def CatchLang()
    @str6 = "\\section{Languages}
            "
    @count11 = 0
    @count12 = 0

    while @count11 < @languages.length
      if @languages[@count11].text.length > 0 &&
         @lvl[@count11].text.length > 0
        @str6 << "\\cvitem{}{#{@languages[@count11]}, \\textit{#{@lvl[@count11]}}}{}
                 "
        @count12 += 1
      end
      @count11 += 1
    end
    if @count12 == 0
      @str6 = ""
    end
  end

  # Metod za gasenje aplikacije pomocu iksica
  def onClose(sender, sel, event)
    $app.exit(0)
  end

  # Putanja do slike
  def openJpgFile(filename)
    @picturePath = "#{filename}"
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

