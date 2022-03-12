# Code from Euruko 2021
# Building a Ruby web app using the Ruby Standard Library (Maple Ong)
# https://www.youtube.com/watch?v=lxczDssLYKA

require 'socket'
require 'uri'
require 'yaml/store'

PORT = 9999
server = TCPServer.new(PORT)

# Database layer: START
store = YAML::Store.new("store.yml")
# Database layer: END

# Action View layer: BEGIN
def daily_steps_form
  <<~STR
    <form action="/add/data" method="post" enctype="application/x-www-form-urlencoded">
      <p><label>Date <input type="date" name="date"></label></p>
      <p><label>Step Count <input type="number" name="step_count"></label></p>
      <p><button>Submit daily data</button></p>
    </form>
  STR
end
# Action View layer: END

puts "✅ Web server is ready. Please open http://localhost:#{PORT}/show/data in your browser"

loop do

  # Rack layer: START
  client = server.accept
  # Accept a HTTP request and parse it
  request_line = client.readline
  method_token, target, version_number = request_line.split
  puts "✅ Received a #{method_token} request to #{target} with #{version_number}"
  # Rack layer: END

  # Action Dispatch layer: START
  # Decide what to respond
  case [method_token, target]
  when ["GET", "/show/data"]
    status_code = "200 OK"

    # Display form and data hash
    response_message = "<h1> Daily Steps Tracker! </h1>" << daily_steps_form
    response_message << "<ul>"

    # Active Record layer: START
    # Read data from file
    all_data = {}
    store.transaction do
      all_data = store[:daily_steps]
    end
    # Active Record layer: END

    if all_data.nil?
      response_message << "<li>There is no data. Please add some</li>"
    else
      all_data.each do |data|
        response_message << "<li> On <b>#{data[:date]}</b>, I walked #{data[:step_count]} steps! </li>"
      end
    end
    response_message << "</ul>"
  when ["POST", "/add/data"]
    status_code = "303 See Other"
    response_message = ''

    # Extract the headers from the request
    headers = {}
    while true
      line = client.readline
      break if line == "\r\n"
      header_name, value = line.split(": ")
      headers[header_name] = value
    end

    # Attain the Content-Length header
    body = client.read(headers['Content-Length'].to_i)

    # Decode it
    new_daily_data = URI.decode_www_form(body).to_h

    # Write user input to file
    store.transaction do
      store[:daily_steps] ||= []
      store[:daily_steps] << new_daily_data.transform_keys(&:to_sym)
    end
  else
    status_code = "404 Not Found"
    response_message = "<b> Didn't hit any endpoints </b>"
  end
  # Action Dispatch layer: START

  # Construct the HTTP request
  http_response = <<~MGG
    HTTP/1.1 #{status_code}
    Content-Type: text/html
    Location: /show/data

    #{response_message}
  MGG

  # Return the HTTP response to client
  client.puts(http_response)
  client.close
end
