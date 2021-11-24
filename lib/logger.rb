class Logger
  def log(url, message)
    $stdout.write "#{url} --> #{message} --> #{Time.now.strftime('%d-%m-%Y_%H:%M:%S')}"
  end
end
