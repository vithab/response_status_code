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

list_urls[4995..5000].each.with_index(1) do |url, index|
  puts "#{index} from #{total_urls}\n\n#{url}"

  begin
    response_object = Response.new(url)
    uri = response_object.get_url_normalize
    response = response_object.get_response

    uri_open = URI.open(uri)

    page = PageParser.new(uri_open)
    p page.get_title
    p page.get_h1
    p page.get_phone
    p page.get_phone.class
    # doc = Nokogiri::HTML(uri_open)
    # p doc.css('title').map { |item| item.text.chomp }.join('; ')
    # p doc.css('h1').map { |item| item.text.chomp }.join('; ')
    
    code = response.code
    message = response.message

    case response
    when Net::HTTPInformation, Net::HTTPSuccess, Net::HTTPRedirection
      availability = 'Yes'
    when Net::HTTPClientError, Net::HTTPServerError
      availability = 'No'
    else
      code = 'No server response'
      message = 'That address is incorrect'
      availability = 'No'
    end
    
    p code
    p message
    p availability

    puts "="*80

  rescue StandardError => e
    puts "Невозможно загрузить #{url}"
    puts e
    puts "="*80

    next
  end
end
