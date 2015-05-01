require 'socket'

webserver = TCPServer.new('127.0.0.1', 5000)

while (session = webserver.accept)
  request = session.gets
  unless request.nil?
    trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')

  	filename = trimmedrequest.chomp

  	if filename == ""
  		filename = "index.html"
  	end

    begin
  		displayfile = File.open(filename, 'r')
        session.print "HTTP/1.1 200 OK\r\n" +
                     "Content-Type: text/html\r\n" +
                     "Connection: close\r\n"

        session.print "\r\n"
  	  content = displayfile.read()
  	  session.print content
  	rescue Errno::ENOENT
      message = "File not found\n"
        session.print "HTTP/1.1 404 Not Found\r\n" +
                     "Content-Type: text/plain\r\n" +
                     "Content-Length: #{message.size}\r\n" +
                     "Connection: close\r\n"

        session.print "\r\n"

        session.print message
  	end
  end

	session.close
end
