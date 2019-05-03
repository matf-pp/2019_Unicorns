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
    @end = []
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

    FXLabel.new(parentFrame, "Company:", :opts => LAYOUT_CENTER_X)
    descFrame = FXHorizontalFrame.new(parentFrame, :opts => LAYOUT_CENTER_X)
    @company.insert(-1, FXTextField.new(descFrame,  50))
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

    #TODO

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
          @end[@count1].text.length > 0 &&
          @position[@count1].text.length > 0 &&
          @company[@count1].text.length > 0
        @str1 << "\\cvitem{#{@start[@count1]} -- #{@end[@count1]}}{\\textbf{#{@position[@count1]}} \\textit{#{@company[@count1]}} }
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

