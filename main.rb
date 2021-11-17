require 'json'
require 'nokogiri'
require 'open-uri'

require_relative 'lib/response'
require_relative 'lib/page_parser'
require_relative 'lib/print_xlsx'
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

HEADERS = ['URL', 'Код ответа сервера', 'Статус', 'Доступность', 
           'Телефон', 'Email', 'Наименование', 'Заголовок']

xlsx = PrintXlsx.new(pages_array, HEADERS)
xlsx.set_headers
xlsx.write_file
