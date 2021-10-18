require 'addressable'
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'write_xlsx'

list_urls = File.readlines('fixtures/input_urls.txt').map(&:chomp)
total_urls = list_urls.count

p list_urls
