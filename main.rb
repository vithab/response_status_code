require 'addressable' # https://github.com/sporkmonger/addressable
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'write_xlsx'
# require 'byebug'

list_urls = File.readlines('fixtures/input_urls.txt').map(&:chomp)
total_urls = list_urls.count

list_urls[89..103].each_with_index do |url, index|
  puts "#{index + 1} from #{total_urls}\n\n#{url}"
  begin
    uri = Addressable::URI.parse(url).normalize
    response = Net::HTTP.get_response(uri)
    # byebug
    # begin
      uri_open = URI.open(uri)
    # rescue StandardError => e
    # end

    doc = Nokogiri::HTML(uri_open)

    p doc.css('title').text
    p doc.css('h1').map { |item| item.text.strip }.join('; ')
    p response.code
    p response.message
    puts "="*80
  # rescue SocketError => e
  rescue StandardError => e
    puts "Невозможно загрузить #{url}"
    puts e
    puts "="*80

    next
  end
end
