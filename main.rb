require 'addressable' # https://github.com/sporkmonger/addressable
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'write_xlsx'
require_relative 'lib/response'
# require 'byebug'

# list_urls = File.readlines('fixtures/input_urls.txt').map(&:chomp)
list_urls = File.readlines('fixtures/test.txt').map(&:chomp)
total_urls = list_urls.count

list_urls[4995..5000].each.with_index(1) do |url, index|
  puts "#{index} from #{total_urls}\n\n#{url}"

  begin
    # uri = Addressable::URI.parse(url).normalize
    # response = Net::HTTP.get_response(uri)
    object = Response.new(url)
    uri = object.get_url_normalize
    response = object.get_response
    
    uri_open = URI.open(uri)

    doc = Nokogiri::HTML(uri_open)
    p doc.css('title').map { |item| item.text.chomp }.join('; ')
    p doc.css('h1').map { |item| item.text.chomp }.join('; ')
    p response.code
    p response.message
    puts "="*80

  rescue StandardError => e
    puts "Невозможно загрузить #{url}"
    puts e
    puts "="*80

    next
  end
end
