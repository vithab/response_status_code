require 'addressable' # https://github.com/sporkmonger/addressable
require 'net/http'

class Response
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def get_url_normalize
    Addressable::URI.parse(url).normalize
  end
  
  def get_response
    Net::HTTP.get_response(get_url_normalize)
  end
end
