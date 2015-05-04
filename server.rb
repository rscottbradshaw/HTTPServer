require 'socket'
require 'byebug'

webserver = TCPServer.new('127.0.0.1', 5000)

d_index = ARGV.index("-d")

if d_index.nil?
  public_dir = "public"
else
  public_dir = ARGV[d_index + 1]
end
puts "Let's use #{public_dir}"

while (session = webserver.accept)
  request = session.gets
  unless request.nil?
    trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')

  	filename = trimmedrequest.chomp

  	if filename == ""
  		filename = "index.html"
    else
      filename = filename.prepend("#{public_dir}/")
  	end

    begin
  		displayfile = File.open(filename, 'r')
        session.print "HTTP/1.1 200 OK\r\n" +
                    #  "Content-Type: text/html\r\n" +
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
