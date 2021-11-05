require 'nokogiri'

class PageParser
  PHONE_NUMBER_REGEX = 
    /\(?\+?[\d]{1,}[\s|-]?\(?[\d]{1,}\)?[\s|-]?[\d]{1,}[\s|-][\d]{1,}[\s|-][\d]{1,4}|$/
  VALID_EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  attr_reader :uri_open, :doc

  def initialize(uri_open)
    @uri_open = uri_open
    @doc = Nokogiri::HTML(uri_open)
  end

  def get_title
    begin
      doc.css('title').map { |item| item.text.chomp.strip }.join('; ')
    rescue ArgumentError
      nil
    end
  end

  def get_h1
    begin
      doc.css('h1').map { |item| item.text.chomp.strip }.join('; ')
    rescue ArgumentError
      nil
    end
  end

  def get_phone
    begin
      doc.text.scan(PHONE_NUMBER_REGEX).delete_if(&:empty?).uniq.map(&:strip)
    rescue ArgumentError
      nil
    end
  end

  def get_email
    begin
      doc.text.scan(VALID_EMAIL_REGEX).delete_if(&:empty?).uniq.map(&:strip)
    rescue ArgumentError
      nil
    end
  end
end
