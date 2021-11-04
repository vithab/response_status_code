require 'nokogiri'

class PageParser
  PHONE_NUMBER_REGEX = 
    /\(?\+?[\d]{1,}[\s|-]?\(?[\d]{1,}\)?[\s|-]?[\d]{1,}[\s|-][\d]{1,}[\s|-][\d]{1,4}|$/

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

  def get_phone
    doc.text.scan(PHONE_NUMBER_REGEX).delete_if(&:empty?).uniq.map(&:strip)
  end
end
