require 'addressable'
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'write_xlsx'

list_urls = File.readlines('fixtures/input_urls.txt').map(&:chomp)
total_urls = list_urls.count

list_urls[0..2].each_with_index do |url, index|
  puts "#{index + 1} from #{total_urls}\n\n#{url}"

  uri = Addressable::URI.parse(url).normalize
  response = Net::HTTP.get_response(uri)

  p uri
  p response.code
  p response.message
end
