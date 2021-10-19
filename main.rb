require 'addressable' # https://github.com/sporkmonger/addressable
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'write_xlsx'

list_urls = File.readlines('fixtures/input_urls.txt').map(&:chomp)
total_urls = list_urls.count

list_urls[0..9].each_with_index do |url, index|
  puts "#{index + 1} from #{total_urls}\n\n#{url}"

  uri = Addressable::URI.parse(url).normalize
  response = Net::HTTP.get_response(uri)
  
  begin
    uri_open = URI.open(uri)
  rescue StandardError => e
  end

  doc = Nokogiri::HTML(uri_open)
  
  p doc.css('title').text
  p response.code
  p response.message
  puts "="*80
end
