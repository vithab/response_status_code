require 'nokogiri'

class PageParser
  attr_reader :uri_open, :doc

  def initialize(uri_open)
    @uri_open = uri_open
    @doc = Nokogiri::HTML(uri_open)
  end

  def get_title
    doc.css('title').map { |item| item.text.chomp }.join('; ')
  end

  def get_h1
    doc.css('h1').map { |item| item.text.chomp }.join('; ')
  end
end
