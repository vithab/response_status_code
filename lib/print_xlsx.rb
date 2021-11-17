require 'write_xlsx'

class PrintXlsx
  attr_reader :workbook, :worksheet, :pages_array, :headers

  def initialize(pages_array, headers = [])
    @pages_array = pages_array
    @workbook = WriteXLSX.new("file_name.xlsx")
    @worksheet = workbook.add_worksheet
    @headers = headers
  end

  def set_headers
    format_header = workbook.add_format
    format_header.set_bold
    format_header.set_bg_color('yellow')
    format_header.set_align('center')

    worksheet.write_row(0, 0, headers, format_header)
  end

  def write_file
    pages_array.each.with_index(1) do |row, index|
      array_values = row.map { |_k, v| v }
      worksheet.write_row(index, 0, array_values)
    end

    workbook.close
  end
end
