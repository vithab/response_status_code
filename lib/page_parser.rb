require 'nokogiri'

class PageParser
  PHONE_NUMBER_REGEX = 
    /\(?\+?[\d]{1,}[\s|-]?\(?[\d]{1,}\)?[\s|-]?[\d]{1,}[\s|-][\d]{1,}[\s|-][\d]{1,4}|$/
  VALID_EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  attr_reader :doc

  def initialize(uri_open)
    @doc = Nokogiri::HTML(uri_open)
  end

  # Находим все теги <title>, заменяем кодировку на utf-8
  def get_title
    begin
      title = doc.css('title').map { |item| item.text.chomp.strip }.join('; ')
      
      unless title.valid_encoding?
        title.encode!( 'UTF-8', 'Windows-1251', invalid: :replace )
      end

      title
    rescue ArgumentError
      nil
    end
  end

  # Находим все теги <H1>, заменяем кодировку на utf-8
  def get_h1
    begin
      h1 = doc.css('h1').map { |item| item.text.chomp.strip }.join('; ')
      
      unless h1.valid_encoding?
        h1.encode!( 'UTF-8', 'Windows-1251', invalid: :replace )
      end

      h1
    rescue ArgumentError
      nil
    end
  end

  # Сканируем html разметку по регулярному выражению,
  # удаляем пустые значения в массиве, делаем уникальными, очищаем white space
  def get_phone
    begin
      doc.text.scan(PHONE_NUMBER_REGEX).delete_if(&:empty?).uniq.map(&:strip).join(', ')
    rescue ArgumentError
      nil
    end
  end

  # Сканируем html разметку по регулярному выражению,
  # удаляем пустые значения в массиве, делаем уникальными, очищаем white space
  def get_email
    begin
      doc.text.scan(VALID_EMAIL_REGEX).delete_if(&:empty?).uniq.map(&:strip).join(', ')
    rescue ArgumentError
      nil
    end
  end
end
