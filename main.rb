require 'json'
require 'nokogiri'
require 'open-uri'
require 'write_xlsx'

require_relative 'lib/response'
require_relative 'lib/page_parser'
require 'byebug'

# list_urls = File.readlines('fixtures/input_urls.txt').map(&:chomp)
list_urls = File.readlines('fixtures/test.txt').map(&:chomp)
total_urls = list_urls.count
pages_array = []

list_urls[4717..4720].each.with_index(1) do |url, index|
  puts "#{index} from #{total_urls}\n\n"

  begin
    response_object = Response.new(url)
    uri = response_object.get_url_normalize
    response = response_object.get_response

    case response
    when Net::HTTPInformation, Net::HTTPSuccess, Net::HTTPRedirection
      availability = 'Yes'
    # Некоторые сервера сайтов отдают коды 4хх, но при этом сайт доступен
    when Net::HTTPClientError#, Net::HTTPServerError
      availability = 'Undefined'
    else
      availability = 'No'
    end

    uri_open = URI.open(uri)
    page = PageParser.new(uri_open)

    page = {
      url:          url,
      code:         response.code,
      message:      response.message,
      availability: availability,
      phone:        page.get_phone,
      email:        page.get_email,
      title:        page.get_title,
      h1:           page.get_h1,
    }

    pages_array << page

    p page
    puts "="*80

  # TODO: сделать логер для ошибок; date, url, exception title
  rescue StandardError => e
    puts "Невозможно загрузить #{url}"
    puts e
    puts Time.now.strftime("%d-%m-%Y %H:%M:%S")
    puts "="*80
  end
end

# p pages_array

workbook = WriteXLSX.new("file_name.xlsx")
worksheet = workbook.add_worksheet

HEADERS = ['URL', 'Код ответа сервера', 'Статус', 'Доступность', 
           'Телефон', 'Email', 'Наименование', 'Заголовок']

format_header = workbook.add_format
format_header.set_bold
format_header.set_bg_color('yellow')
format_header.set_align('center')

worksheet.write_row(0, 0, HEADERS, format_header)

pages_array.each.with_index(1) do |row, index|
  array_values = row.map { |_k, v| v }
  worksheet.write_row(index, 0, array_values)
end

workbook.close
