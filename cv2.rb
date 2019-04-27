#!/usr/bin/env ruby
# GUI za cetvrti CV
require 'fox16'
require 'tempfile'
require 'thread'
include Fox

class CV2 < FXMainWindow

  def initialize()
    super($app, "CV express", :opts => DECOR_ALL, :width => 570, :height => 600)
    self.connect(SEL_CLOSE, method(:onClose))

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )

    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)

    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblInfo = FXLabel.new(infoFrame, "About:", :opts => LAYOUT_CENTER_X)
    lblInfo.textColor = Fox.FXRGB(25, 170, 10)
    lblInfo.font = FXFont.new(app, "Geneva", 12)

    info = FXHorizontalFrame.new(infoFrame, :opts => LAYOUT_CENTER_X)
    matrixInfo = FXMatrix.new(info, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblName = FXLabel.new(matrixInfo, "First name:  ")
    @tfName = FXTextField.new(matrixInfo, 30)
    lblLastName = FXLabel.new(matrixInfo, "Last name:  ")
    @tfLastName = FXTextField.new(matrixInfo, 30)

    lblAddress = FXLabel.new(matrixInfo, "Address:  ")
    @tfAddress = FXTextField.new(matrixInfo, 30)
    lblCity = FXLabel.new(matrixInfo, "City, State 0000-0000:  ")
    @tfCity = FXTextField.new(matrixInfo, 30)
    lblCountry = FXLabel.new(matrixInfo, "Country:  ")
    @tfCountry = FXTextField.new(matrixInfo, 30)

    lblPhone = FXLabel.new(matrixInfo, "Phone number:  ")
    @tfPhone = FXTextField.new(matrixInfo, 30)
    lblMail = FXLabel.new(matrixInfo, "E-mail:  ")
    @tfMail = FXTextField.new(matrixInfo, 30)
    lblWeb = FXLabel.new(matrixInfo, "Website:  ")
    @tfWeb = FXTextField.new(matrixInfo, 30)

    FXHorizontalSeparator.new(infoFrame)

    # Nova celina, radno iskustvo
    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X)
    lblExp = FXLabel.new(expFrame, "Experience:", :opts => LAYOUT_FILL_X)
    lblExp.textColor = Fox.FXRGB(230, 30, 5)
    lblExp.font = FXFont.new(app, "Geneva", 12)

    btnExp = FXButton.new(expFrame, "Add fields", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @expSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @start = []
    @end = []
    @position = []
    @jobDesc = []
    btnExp.connect(SEL_COMMAND) do
      makeLayoutExp()
      @expSpace.create # create server-side resources
      @expSpace.recalc # mark parent layout as dirty
    end

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
      @eduSpace.create # create server-side resources
      @eduSpace.recalc # mark parent layout as dirty
    end

    # Nova celina, interesovanja
    intFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    @lblInt = FXLabel.new(intFrame, "Interests:", :opts => LAYOUT_CENTER_X)
    @lblInt.textColor = Fox.FXRGB(234, 184,  35)
    @lblInt.font = FXFont.new(app, "Geneva", 12)

    interests = FXHorizontalFrame.new(intFrame, :opts => LAYOUT_CENTER_X)
    matrixInt = FXMatrix.new(interests, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblProf = FXLabel.new(matrixInt, "Professional:  ")
    pomocni1 = FXHorizontalFrame.new(matrixInt, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @taProf = FXText.new(pomocni1, :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    @taProf.width = 350

    lblPersonal = FXLabel.new(matrixInt, "Personal:  ")
    pomocni2 = FXHorizontalFrame.new(matrixInt, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @taPersonal = FXText.new(pomocni2, :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    @taPersonal.width = 350

    FXHorizontalSeparator.new(intFrame)

    # Nova celina, nagrade
    skillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblSkills = FXLabel.new(skillsFrame, "Skills:", :opts => LAYOUT_CENTER_X)
    lblSkills.textColor = Fox.FXRGB(170, 5, 170)
    lblSkills.font = FXFont.new(app, "Geneva", 12)

    pomocni3 = FXHorizontalFrame.new(skillsFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @taDescription = FXText.new(pomocni3, :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    @taDescription.width = 450

    FXHorizontalSeparator.new(skillsFrame)

    #btnAwards = FXButton.new(awardsFrame, "Add fields", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    #@awardsSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    #@year = []
    #@awards = []
    #@descriptionAwards = []
    #btnAwards.connect(SEL_COMMAND) do
    #  makeLayoutAwards()
    #  @awardsSpace.create
    #  @awardsSpace.recalc
    #end

    # Nova celina, dugmici
    btnFrame = FXHorizontalFrame.new(frame, :opts => LAYOUT_RIGHT|FRAME_THICK)
    # TODO
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

  # Radno iskustvo, polja
  def makeLayoutExp()
    parentFrame = FXVerticalFrame.new(@expSpace, :opts => LAYOUT_FILL)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Period:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Position:", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    positionFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    @start.insert(-1, FXTextField.new(yearFrame,  5))

    FXLabel.new(yearFrame, " - ")
    @end.insert(-1, FXTextField.new(yearFrame, 5))
    @position.insert(-1, FXTextField.new(positionFrame, 38))

    FXLabel.new(parentFrame, "Job description:", :opts => LAYOUT_CENTER_X)
    descFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @jobDesc.insert(-1, FXText.new(descFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @jobDesc[-1].width = 450

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

    FXLabel.new(parentFrame, "Studies description: ", :opts => LAYOUT_CENTER_X)
    descFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @desc.insert(-1, FXText.new(descFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @desc[-1].width = 450

    FXHorizontalSeparator.new(parentFrame)
  end

  # Nagrade, polja
  #def makeLayoutAwards()
  #  pFrame = FXVerticalFrame.new(@awardsSpace, :opts => LAYOUT_FILL)
  #  matrix = FXMatrix.new(pFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

  #  FXLabel.new(matrix, "Year:", :opts => LAYOUT_FILL_X)
  #  FXLabel.new(matrix, "Name: ", :opts=> LAYOUT_FILL_X)

  #  yearFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
  #  awFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)

  #  @year.insert(-1, FXTextField.new(yearFrame,  5))
  #  @awards.insert(-1, FXTextField.new(awFrame, 45))

  #  FXLabel.new(pFrame, "Description:", :opts => LAYOUT_CENTER_X)
  #  dFrame = FXHorizontalFrame.new(pFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
  #  @descriptionAwards.insert(-1, FXText.new(dFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
  #  @descriptionAwards[-1].width = 450

  #  FXHorizontalSeparator.new(pFrame)
  #end

  #TODO
  def onSubmit(sender, sel, event)
    system("cp ./CV2/cv2.tex '#{@tfName}.tex'")
    file_edit("#{@tfName}.tex", 'ImeKorisnika', @tfName.text)
    file_edit("#{@tfName}.tex", 'PrezimeKorisnika', @tfLastName.text)

    file_edit("#{@tfName}.tex", 'brojTelefona', @tfPhone.text)
    file_edit("#{@tfName}.tex", 'mejlKorisnika', @tfMail.text)
    file_edit("#{@tfName}.tex", 'linkVebsajta', @tfWeb.text)
    file_edit("#{@tfName}.tex", 'UlicaIBroj', @tfAddress.text)
    file_edit("#{@tfName}.tex", 'mestoBoravka', @tfCity.text)
    file_edit("#{@tfName}.tex", 'Drzava', @tfCountry.text)

    # Fja koja obradjuje uneto iskustvo
    Catch1()
    file_edit("#{@tfName}.tex", 'RadnoIskustvoKorisnika', @str1)

    # Fja koja obradjuje uneto obrazovanje
    Catch2()
    file_edit("#{@tfName}.tex", 'ObrazovanjeKorisnika', @str3)

    file_edit("#{@tfName}.tex", 'profesionalnaInteresovanja', @taProf.text)
    file_edit("#{@tfName}.tex", 'privatnaInteresovanja', @taPersonal.text)

    file_edit("#{@tfName}.tex", 'Nagrade', @taDescription.text)

    system("xelatex '#{@tfName}.tex'")
    system("xelatex '#{@tfName}.tex'")

    system("mv '#{@tfName}.pdf' ~/Desktop")
    system("rm '#{@tfName}'.* ")

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

  # Obrada radnog iskustva
  def Catch1()
    @str1 = "    \\LARGE
             \\noindent\\colorbox{materialRed}
             {\\parbox[c][25pt][c]{\\textwidth}{\\hspace{15pt}\\textcolor{white}{Experience}}}
             \\large
             \\vspace*{10pt}
             "
    @count1 = 0
    @count2 = 0

    while @count1 < @start.length
      if @start[@count1].text.length > 0 &&
          @end[@count1].text.length > 0 &&
          @position[@count1].text.length > 0 &&
          @jobDesc[@count1].text.length > 0
        @str1 << "\\ExperienceEntry{#{@start[@count1]}}{#{@end[@count1]}}{#{@position[@count1]}}{#{@jobDesc[@count1]}}{}\\break"
        @count2 += 1
      end
      @count1 += 1
    end
    @str1 << "
            \\vspace*{5pt}"
    if @count2 == 0
      @str1 = ""
    end
  end

  def Catch2()
    @str3 = "    \\LARGE
             \\noindent\\colorbox{materialBlue}
             {\\parbox[c][25pt][c]{\\textwidth}{\\hspace{15pt}\\textcolor{white}{Education}}}
             \\large
             \\vspace*{10pt}
             "
    @count5 = 0
    @count6 = 0

    while @count5 < @startYear.length
      if @startYear[@count5].text.length > 0 &&
          @endYear[@count5].text.length > 0 &&
          @eduLvl[@count5].text.length > 0 &&
          @desc[@count5].text.length > 0
        @str3 << "\\EducationEntry{#{@startYear[@count5]}}{#{@endYear[@count5]}}{#{@eduLvl[@count5]}}{#{@desc[@count5]}}{}\\break"
        @count6 += 1
      end
      @count5 += 1
    end
    @str3 << "
    \\vspace*{5pt}"
    if @count6 == 0
      @str3 = ""
    end
  end

  #def Catch3()
  #  @str2 = "  \\LARGE
  #           \\noindent\\colorbox{materialPurple}
  #            {\\parbox[c][25pt][c]{\\textwidth}{\\hspace{15pt}\\textcolor{white}{Awards}}}
  #             \\large
  #             \\vspace*{5pt}
  #             "
  #  @count3 = 0
  #  @count4 = 0

   # while @count3 < @year.length
    #  if @year[@count3].text.length > 0 &&
    #      @awards[@count3].text.length > 0 &&
    #      @descriptionAwards[@count3].text.length > 0
    #    @str2 << " \\AwardEntry{#{@year[@count3]}}{#{@awards[@count3]}}{#{@descriptionAwards[@count3]}}{}\\break"
    #    @count4 += 1
    #  end
    #  @count3 += 1
    #end
    #@str2 << "
    #\\vspace*{5pt}"
    #if @count4 == 0
    #  @str2 = ""
    #end
  #end

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

