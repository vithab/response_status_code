class Logger
  SEPARATOR = ' --> '
  
  def initialize
    @prefix = "#{Time.now.strftime('%d-%m-%Y_%H:%M:%S')}"
    SEPARATOR 
  end

  def log(url, message)
    $stdout.write "#{url}#{SEPARATOR}#{message}#{SEPARATOR}#{@prefix}"
  end

  def write(url, message)
    File.open('logs/log.txt', 'a+:UTF-8') do |f|
      f.write url
      f.write SEPARATOR
      f.write message
      f.write SEPARATOR
      f.write @prefix
      f.write "\n"
    end
  end
end
