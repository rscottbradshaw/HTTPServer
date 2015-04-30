require 'socket'

webserver = TCPServer.new('127.0.0.1', 2523)

while (session = webserver.accept)
	session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"

	request = session.gets

	trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')

	filename = trimmedrequest.chomp

	if filename == ""
		filename = "index.html"
	end

	begin
		displayfile = File.open(filename, 'r')
		content = displayfile.read()
		session.print content
	rescue Errno::ENOENT
		session.print "File is not found"
	end

	session.close
end













# require 'socket'
#
# server = TCPServer.new('localhost', 2523)
# loop do
#   Thread.start(server.accept) do |client|
#     client.puts "Hello Scott's World!"
#     client.close
#   end
# end

# require 'socket'
# require 'uri'
#
# WEB_ROOT = 'public'
#
# CONTENT_TYPE_MAPPING = {
#   'html' => 'text/html',
#   'txt' => 'text/plain',
#   'png' => 'image/png',
#   'jpg' => 'image/jpeg'
# }
#
# DEFAULT_CONTENT_TYPE = 'application/octet-stream'
#
# def content_type(path)
#   ext = File.extname(path).split(".").last
#   CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
# end
#
# def requested_file(request_line)
#   request_uri = request_line.split(" ")[1]
#   path        = URI.unescape(URI(request_uri).path)
#
#   clean = []
#
#   parts = path.split("/")
#
#   parts.each do |part|
#     next if part.empty? || part == '.'
#     part == '..' ? clean.pop : clean << part
#   end
#   File.join(WEB_ROOT, *clean)
# end
#
# server = TCPServer.new('localhost', 5000)
#
# loop do
#   socket = server.accept
#   request_line = socket.gets
#
#   STDERR.puts request_line
#
#   path = requested_file(request_line)
#
#   if File.exist?(path) && !File.directory?(path)
#     File.open(path, "rb") do |file|
#       socket.print "HTTP/1.1 200 OK\r\n" +
#                    "Content-Type: #{content_type(file)}\r\n" +
#                    "Content-Length: #{file.size}\r\n"
#                    "Connection: close\r\n"
#
#       socket.print "\r\n"
#
#       IO.copy_stream(file,socket)
#     end
#   else
#     message = "File not found\n"
#
#       socket.print "HTTP/1.1 404 Not Found\r\n" +
#                    "Content-Type: text/plain\r\n"
#                    "Content-Length: #{message.size}\r\n"
#                    "Connection: close\r\n"
#
#       socket.print "\r\n"
#
#       socket.print message
#     end
#
#     socket.close
#   end
