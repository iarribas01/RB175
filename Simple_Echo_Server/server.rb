require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")

  path, params = path_and_params.split("?")
  
  params = (params || "").split("&").each_with_object({}) do |param, hash|
    key, value = param.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end


server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  # GET /?rolls=2&sides=6 HTTP/1.1
  http_method, path, params = parse_request(request_line)
  rolls = params["rolls"].to_i
  sides = params["sides"].to_i
  
  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"
  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"
  
  client.puts "<a href='?number=#{number+1}'>Add one</a>"
  client.puts "<a href='?number=#{number-1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"
  client.close
end

# converts array of strings of params to hash
def to_hash(arr)
  result = {}

  arr.each do |str|
    key, value = str.split("=")
    result[key] = value
  end

  result
end