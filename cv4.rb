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

    @scroll = FXScrollWindow.new(self, :width=>500, :height => 600, :opts => LAYOUT_FILL )
    # Osnovni frame, u kome se sadrze svi drugi, roditeljski
    frame = FXVerticalFrame.new(@scroll, :width => 480,:opts => LAYOUT_FILL_X|LAYOUT_FIX_WIDTH)

    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblInfo = FXLabel.new(infoFrame, "About:", :opts => LAYOUT_CENTER_X)
    lblInfo.textColor = Fox.FXRGB(120, 5, 120)
    lblInfo.font = FXFont.new(app, "Geneva", 12)

    # Osnovne informacije o korisniku
    info = FXHorizontalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    matrixInfo = FXMatrix.new(info, n=2, :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL_X)

    lblName = FXLabel.new(matrixInfo, "First and last name:  ")
    @tfName = FXTextField.new(matrixInfo, 39)

    lblAddress = FXLabel.new(matrixInfo, "Address:  ")
    @tfAddress = FXTextField.new(matrixInfo, 39)

    lblPhone = FXLabel.new(matrixInfo, "Phone number:  ")
    @tfPhone = FXTextField.new(matrixInfo, 39)

    lblMail = FXLabel.new(matrixInfo, "E-mail:  ")
    @tfMail = FXTextField.new(matrixInfo, 39)

    lblPosition = FXLabel.new(matrixInfo, "Position:  ")
    @tfPosition = FXTextField.new(matrixInfo, 39)

    # Nova celina, vestine za komunikaciju
    comSkillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    @lblComSkills = FXLabel.new(comSkillsFrame, "Languages: ", :opts => LAYOUT_CENTER_X)
    @lblComSkills.textColor = Fox.FXRGB(120, 5, 120)
    @lblComSkills.font = FXFont.new(app, "Geneva", 12)

    comHFrame = FXHorizontalFrame.new(comSkillsFrame, :opts => LAYOUT_CENTER_X)
    @tfLang = FXTextField.new(comHFrame, 55)

    # Nova celina, profesionalne vestine
    proSkillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblProSkills = FXLabel.new(proSkillsFrame, "Programming skills: ", :opts => LAYOUT_CENTER_X)
    lblProSkills.textColor = Fox.FXRGB(120, 5, 120)
    lblProSkills.font = FXFont.new(app, "Geneva", 12)

    pomocniFrame = FXHorizontalFrame.new(proSkillsFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @taDesc = FXText.new(pomocniFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    @taDesc.width = 450
    @taDesc.text = ""

    # Nova celina, interesovanja
    intFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    @lblInt = FXLabel.new(intFrame, "Interests:", :opts => LAYOUT_CENTER_X)
    @lblInt.textColor = Fox.FXRGB(0, 70, 190)
    @lblInt.font = FXFont.new(app, "Geneva", 12)
    pomocniIntFrame = FXHorizontalFrame.new(intFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @taInt = FXText.new(pomocniIntFrame, :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    @taInt.width = 450
    @taInt.text = ""

    # Nova celina, steceno obrazovanje
    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_CENTER_X)
    lblEdu = FXLabel.new(eduFrame, "Education: ", :opts => LAYOUT_CENTER_X)
    lblEdu.textColor = Fox.FXRGB(215, 5, 20)
    #lblEdu.textColor = Fox.FXRGB(0, 80, 150)
    lblEdu.font = FXFont.new(app, "Geneva", 12)

    ye1 = FXVerticalFrame.new(eduFrame)
    yearAndEdu1 = FXHorizontalFrame.new(ye1, :opts => PACK_UNIFORM_HEIGHT)
    @tfStartHighSchool = FXTextField.new(yearAndEdu1,  6)
    lblLine1 = FXLabel.new(yearAndEdu1, " - ")
    @tfEndHighSchool = FXTextField.new(yearAndEdu1, 6)
    @tfDiplomaHS = FXTextField.new(yearAndEdu1, 39)
    yearEdu1 = FXHorizontalFrame.new(ye1, :opts => PACK_UNIFORM_HEIGHT|LAYOUT_RIGHT)
    @tfEduHighSchool = FXTextField.new(yearEdu1, 39, :opts => TEXTFIELD_NORMAL)

    ye2 = FXVerticalFrame.new(eduFrame)
    yearAndEdu2 = FXHorizontalFrame.new(ye2, :opts => PACK_UNIFORM_HEIGHT)
    @tfStartUniv = FXTextField.new(yearAndEdu2,  6)
    lblLine2 = FXLabel.new(yearAndEdu2, " - ")
    @tfEndUniv = FXTextField.new(yearAndEdu2, 6)
    @tfDiplomaUniv = FXTextField.new(yearAndEdu2, 39)
    yearEdu2 = FXHorizontalFrame.new(ye2, :opts => PACK_UNIFORM_HEIGHT|LAYOUT_RIGHT)
    @tfEduUniv = FXTextField.new(yearEdu2, 39, :opts => TEXTFIELD_NORMAL)

    # Nova celina, radno iskustvo
    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X)
    expLabel = FXLabel.new(expFrame, "Experience:", :opts => LAYOUT_FILL_X)
    expLabel.textColor = Fox.FXRGB(235, 55, 10)
    expLabel.font = FXFont.new(app, "Geneva", 12)

    # Frame za dugmice
    expButton = FXButton.new(expFrame, "Add new row", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @expSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @startYear = []
    @endYear = []
    @position = []
    @company = []
    @describe = []
    expButton.connect(SEL_COMMAND) do
      makeLayoutExp()
      @expSpace.create # create server-side resources
      @expSpace.recalc # mark parent layout as dirty
    end


    appFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X)
    appLabel = FXLabel.new(appFrame, "Projects:", :opts => LAYOUT_FILL_X)
    appLabel.textColor = Fox.FXRGB(30, 155, 5)
    appLabel.font = FXFont.new(app, "Geneva", 12)

    # Frame za dugmice
    appButton = FXButton.new(appFrame, "Add new row", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @appSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)
    @year = []
    @name = []
    @description = []
    appButton.connect(SEL_COMMAND) do
      makeLayoutApp()
      @appSpace.create # create server-side resources
      @appSpace.recalc # mark parent layout as dirty
    end


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

  def makeLayoutExp()
    bigFrame = FXVerticalFrame.new(@expSpace, :opts => LAYOUT_FILL)
    matrica = FXMatrix.new(bigFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrica, "Period:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrica, "Position:", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrica, LAYOUT_FILL_X)
    positionFrame = FXHorizontalFrame.new(matrica, LAYOUT_FILL_X)
    @startYear.insert(-1, FXTextField.new(yearFrame,  6))

    FXLabel.new(yearFrame, " - ")
    @endYear.insert(-1, FXTextField.new(yearFrame, 6))
    @position.insert(-1, FXTextField.new(positionFrame, 40))

    FXLabel.new(bigFrame, "Company:", :opts => LAYOUT_CENTER_X)
    @company.insert(-1, FXTextField.new(bigFrame, 60, :opts=>LAYOUT_CENTER_X|TEXTFIELD_NORMAL))

  end

  # Projekti, polja
  def makeLayoutApp()
    parentFrame = FXVerticalFrame.new(@appSpace, :opts => LAYOUT_CENTER_X)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_CENTER_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Year:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Name of the project:", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrix, LAYOUT_CENTER_X)
    appNameFrame = FXHorizontalFrame.new(matrix, LAYOUT_CENTER_X)
    @year.insert(-1, FXTextField.new(yearFrame,  7))
    @name.insert(-1, FXTextField.new(appNameFrame, 47))

    FXLabel.new(parentFrame, "Description", :opts => LAYOUT_CENTER_X)
    descriptionFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_CENTER_X|FRAME_THICK)
    @description.insert(-1, FXText.new(descriptionFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @description[-1].width = 460
  end

  def onSubmit(sender, sel, event)
    system("cp ./CV4/cv4.tex '#{@tfName}.tex'")
    file_edit("#{@tfName}.tex", 'Ime', @tfName.text)
    file_edit("#{@tfName}.tex", 'Adresa', @tfAddress.text)
    file_edit("#{@tfName}.tex", 'telefon', @tfPhone.text)
    file_edit("#{@tfName}.tex", 'mejl', @tfMail.text)
    file_edit("#{@tfName}.tex", 'Jezici', @tfLang.text)
    file_edit("#{@tfName}.tex", 'progJez', @taDesc.text)
    file_edit("#{@tfName}.tex", 'interesovanja', @taInt.text)
    file_edit("#{@tfName}.tex", 'Zanimanje', @tfPosition.text)

    file_edit("#{@tfName}.tex", 'Jezici', @tfLang.text)
    file_edit("#{@tfName}.tex", 'progJez', @taDesc.text)
    file_edit("#{@tfName}.tex", 'interesovanja', @taInt.text)

    file_edit("#{@tfName}.tex", 'pocetak1', @tfStartHighSchool.text)
    file_edit("#{@tfName}.tex", 'kraj1', @tfEndHighSchool.text)
    file_edit("#{@tfName}.tex", 'nivoStudija1', @tfDiplomaHS.text)
    file_edit("#{@tfName}.tex", 'ObrazovnaUstanova1', @tfEduHighSchool.text)

    file_edit("#{@tfName}.tex", 'pocetak2', @tfStartUniv.text)
    file_edit("#{@tfName}.tex", 'kraj2', @tfEndUniv.text)
    file_edit("#{@tfName}.tex", 'nivoStudija2', @tfDiplomaUniv.text)
    file_edit("#{@tfName}.tex", 'ObrazovnaUstanova2', @tfEduUniv.text)

    Catch1()
    file_edit("#{@tfName}.tex", 'NestoStoTrazimo', @str1)
    Catch2()
    file_edit("#{@tfName}.tex", 'ProjektiIAplikacije', @str2)

    system("xelatex '#{@tfName}.tex'")
    system("xelatex '#{@tfName}.tex'")

    system("mv '#{@tfName}.pdf' ~/Desktop")
    system("rm '#{@tfName}'.* ")

    # Iskacuci prozorcic sa porukom
    @mess = FXMessageBox.information(self, MBOX_OK, "Done", "Your CV is ready!\n")
    #@mess.width = 150
    #@mess.height = 70

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
    @str1 = "\\section{experience}
            \\begin{entrylist}
                "

    @count1 = 0
    @count2 = 0
    puts @startYear.length
    while @count1 < @startYear.length
      if @startYear[@count1].text.length > 0 &&
          @endYear[@count1].text.length > 0 &&
          @company[@count1].text.length > 0 &&
          @position[@count1].text.length > 0

        @str1 << " \\entry{ #{@startYear[@count1]} -- #{@endYear[@count1]}}
                   {#{@company[@count1]}}
                   {}
                   {\\emph{#{@position[@count1]}}}
                   "
        @count2 += 1
      end
      @count1 += 1
    end
    @str1 << "
    \\end{entrylist}"
    if @count2 == 0
      @str1 = ""
    end
  end

  def Catch2()
    @str2 = " \\section{projects}
            \\begin{entrylist}
                "
    @count3 = 0
    @count4 = 0

    #puts @startYear.length
    while @count3 < @year.length
      if @year[@count3].text.length > 0 &&
          @name[@count3].text.length > 0 &&
          @description[@count3].text.length > 0

        @str2 << " \\entry
                        {#{@year[@count3]}}
                        {#{@name[@count3]}}
                        {\\href{}{}}
                        {#{@description[@count3]}}
                   "
        @count4 += 1
      end
      @count3 += 1
    end
    @str2 << "
    \\end{entrylist}"
    if @count4 == 0
      @str2 = ""
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

