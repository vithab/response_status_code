class Logger
  def initialize
    @prefix = " --> #{Time.now.strftime('%d-%m-%Y_%H:%M:%S')}"
  end

  def log(url, message)
    $stdout.write "#{url} --> #{message}} #{@prefix}"
  end

  def write(url, message)
    
  end
end
