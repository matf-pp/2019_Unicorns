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


    infoFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblInfo = FXLabel.new(infoFrame, "About:", :opts => LAYOUT_CENTER_X)
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

    # Nova celina, vestine za komunikaciju
    comSkillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    @lblComSkills = FXLabel.new(comSkillsFrame, "Languages: ", :opts => LAYOUT_CENTER_X)
    #@lblComSkills.textColor = Fox.FXRGB(45, 150, 0)
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
    proSkillsFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblProSkills = FXLabel.new(proSkillsFrame, "Programming skills: ", :opts => LAYOUT_CENTER_X)
    lblProSkills.textColor = Fox.FXRGB(120, 5, 120)
    lblProSkills.font = FXFont.new(app, "Geneva", 12)

    pomocniFrame = FXHorizontalFrame.new(proSkillsFrame, :opts => LAYOUT_LEFT|FRAME_THICK)
    @taDesc = FXText.new(pomocniFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    @taDesc.width = 450
    @taDesc.text = ""

    #TODO
    # Nova celina, interesovanja
    intFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblInt = FXLabel.new(intFrame, "Interests:", :opts => LAYOUT_CENTER_X)
    lblInt.textColor = Fox.FXRGB(0, 70, 190)
    lblInt.font = FXFont.new(app, "Geneva", 12)
    pomocniIntFrame = FXHorizontalFrame.new(intFrame, :opts => LAYOUT_LEFT|FRAME_THICK)
    taInt = FXText.new(pomocniIntFrame, :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH)
    taInt.width = 450
    taInt.text = ""

    # Nova celina, steceno obrazovanje
    eduFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL)
    lblEdu = FXLabel.new(eduFrame, "Education: ", :opts => LAYOUT_CENTER_X)
    lblEdu.textColor = Fox.FXRGB(215, 5, 20)
    #lblEdu.textColor = Fox.FXRGB(0, 80, 150)
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

    # Nova celina, radno iskustvo
    expFrame = FXVerticalFrame.new(frame, :opts => LAYOUT_FILL_X)
    expLabel = FXLabel.new(expFrame, "Experience:", :opts => LAYOUT_FILL_X)
    expLabel.textColor = Fox.FXRGB(235, 55, 10)
    expLabel.font = FXFont.new(app, "Geneva", 12)

    # Frame za dugmice
    expButton = FXButton.new(expFrame, "Add new row", :opts => FRAME_RAISED |FRAME_THICK |LAYOUT_CENTER_X)
    @expSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_FILL|MATRIX_BY_COLUMNS)
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
    @appSpace = FXMatrix.new(frame, n=1, :opts => LAYOUT_FILL|MATRIX_BY_COLUMNS)
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
    @position.insert(-1, FXTextField.new(positionFrame, 45))

    FXLabel.new(bigFrame, "Company:", :opts => LAYOUT_CENTER_X)
    @company.insert(-1, FXTextField.new(bigFrame, 65, :opts=>LAYOUT_CENTER_X|TEXTFIELD_NORMAL))

    FXLabel.new(bigFrame, "Description", :opts => LAYOUT_CENTER_X)
    describeFrame = FXHorizontalFrame.new(bigFrame, :opts => LAYOUT_FILL_X|FRAME_THICK)
    @describe.insert(-1, FXText.new(describeFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @describe[-1].width = 520
  end

  # Projekti, polja
  def makeLayoutApp()
    parentFrame = FXVerticalFrame.new(@appSpace, :opts => LAYOUT_FILL)
    matrix = FXMatrix.new(parentFrame, n=2, :opts => LAYOUT_FILL_X|MATRIX_BY_COLUMNS)

    FXLabel.new(matrix, "Year:", :opts => LAYOUT_CENTER_X)
    FXLabel.new(matrix, "Name of the project:", :opts=> LAYOUT_CENTER_X)

    yearFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    appNameFrame = FXHorizontalFrame.new(matrix, LAYOUT_FILL_X)
    @year.insert(-1, FXTextField.new(yearFrame,  7))
    @name.insert(-1, FXTextField.new(appNameFrame, 47))

    FXLabel.new(parentFrame, "Description", :opts => LAYOUT_CENTER_X)
    descriptionFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_LEFT|FRAME_THICK)
    @description.insert(-1, FXText.new(descriptionFrame,  :opts => TEXT_WORDWRAP|LAYOUT_FIX_WIDTH))
    @description[-1].width = 460
  end

  def onSubmit(sender, sel, event)
    system("cp cv4.tex '#{@tfName}.tex'")
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

    system("pdflatex '#{@tfName}.tex'")
    system("pdflatex '#{@tfName}.tex'")

    system("mv '#{@tfName}.pdf' ~/Desktop")
    system("rm '#{@tfName}'.* ")
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

