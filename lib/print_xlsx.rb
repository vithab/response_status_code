require 'write_xlsx'

class PrintXlsx
  attr_reader :workbook, :worksheet, :pages_array, :headers

  # Принимаем в конструктор массив страниц, и заголовков для xlsx файла
  def initialize(pages_array, headers = [])
    @pages_array = pages_array
    @workbook = WriteXLSX.new("./xlsx/file_#{Time.now.strftime("%d-%m-%Y_%H-%M-%S")}.xlsx")
    @worksheet = workbook.add_worksheet
    @headers = headers
  end

  # Запись в документ на лист worksheet построчно
  def write_file
    # записываем отформатированные заголовки столбцов
    worksheet.write_row(0, 0, headers, set_cell_formating_headers)

    # проходимся по массиву хешей, достаём значения и пишем построчно на лист
    pages_array.each.with_index(1) do |row, index|
      array_values = row.map { |_k, v| v }
      worksheet.write_row(index, 0, array_values)
    end
    
    # Устанавливаем центрирование текста в столбцах 2, 3, 4 (отсчёт с 0)
    worksheet.set_column(1, 3, 0, align_column_format)
    workbook.close
  end

  private
  
  # Устанавливаем форматирование ячеек заголовка документа (шапка)
  def set_cell_formating_headers
    workbook.add_format(
      border: 1,
      bold: 1,
      bg_color: '#7FFFD4',
      align: 'center',
      valign: 'vcenter'
    )
  end
  
  # Устанавливаем центрирование текста (горизонтально / вертикально)
  def align_column_format
    workbook.add_format(align: 'center', valign: 'vcenter')
  end  
end
