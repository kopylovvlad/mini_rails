require 'socket'
require 'uri'
require 'yaml/store'
require 'securerandom'

PORT = 9999

# Base. Rack layer: START
class MyServer
  def initialize
    @server = TCPServer.new(PORT)
    puts "✅ Вебсервер готов, товарищь. Теперь открой в браузере http://localhost:#{PORT}/"
  end

  def fetch_data
    client = @server.accept
    # Accept a HTTP request and parse it
    request_line = client.readline
    method_token, target, version_number = request_line.split
    puts "✅ Приняли запрос с методом #{method_token} на ручку #{target} с версией #{version_number}"
    [client, method_token, target]
  end
end
# Base. Rack layer: END


# Base. Database layer: START
class ActiveRecord
  def self.table_name
    "#{name.downcase}s"
  end

  def self.all
    store.transaction do
      store[table_name.to_sym]
    end
  end

  def self.add_data(new_item)
    store.transaction do
      store[table_name.to_sym] << new_item
    end
  end

  def self.delete_by_id(id)
    store.transaction do
      store[table_name.to_sym].reject! do |i|
        i[:id] == id
      end
    end
  end

  private

  def self.store
    @store ||= begin
      store = YAML::Store.new("#{table_name}.yml")
      store.transaction do
        store[table_name.to_sym] ||= []
      end
      store
    end
  end
end
# Base. Database layer: END


# Base. Action View layer: BEGIN
class ActionView
  def html5_doctype
    <<~STR
      <!DOCTYPE html>
      <html lang="ru">
      <head>
        <title>Мой список дел!</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
      </head>
      <body>
        <div class="container">
          <div class="row">
            <div class="col-sm-8">
              #{yield if block_given?}
            </div>
            <div class="col-sm-4"></div>
          </div>
        </div>
      </body>
      </html>
    STR
  end

  def render_response(status_code, response_message)
    # Construct the HTTP request
    <<~MSG
      HTTP/1.1 #{status_code}
      Content-Type: text/html
      Location: /

      #{html5_doctype { response_message }}
    MSG
  end
end
# Base. Action View layer: END


# Base. Action Controller layer: START
class ActionController
  def initialize(client)
    @params = ActionParams.parse(client)
    @action_view = view_class.new
  end

  private

  attr_reader :params, :action_view

  def no_body
    ''
  end

  def view_class
    ActionView
  end
end
# Base. Action Controller layer: END


# Base. Action Params layer: START
class ActionParams
  def self.parse(client)
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
    URI.decode_www_form(body).to_h.transform_keys(&:to_sym)
  end
end
# Base. Action Params layer: START


# Application. Models layer: START
class Item < ActiveRecord
end
# Application. Models layer: END


# Application. Controllers layer: START
class ItemsController < ActionController
  def index
    response_message = ItemsView.new.index(Item.all)
    ["200 OK", response_message]
  end

  def create
    new_item = params.transform_keys(&:to_sym).merge(id: SecureRandom.uuid)
    Item.add_data(new_item)
    ["303 See Other", no_body]
  end

  def destroy
    Item.delete_by_id(params[:item_id])
    ["303 See Other", no_body]
  end

  private

  def view_class
    ItemsView
  end
end

class NotFoundController < ActionController
  def index
    response_message = <<~MSG
      <b> Страница не найдена </b><br/>
      <a href="/">Перейти на главную</a>
    MSG
    ["404 Not Found", response_message]
  end
end
# Application. Controllers layer: END


# Application. View layer: START
class ItemsView < ActionView
  def index(all_data)
    # Display form and data hash
    response_message = "<h1> Мой список дел! </h1>"
    response_message << render_todo_items_form
    response_message << '<ul class="list-group">'
    if all_data.nil? || all_data.size == 0
      response_message << '<li class="list-group-item">Данных нет. Пожалуйста добавьте данные на сегодня</li>'
    else
      all_data.each do |data|
        response_message << render_item_list(data)
      end
    end
    response_message << "</ul>"
    response_message
  end

  private

  def render_todo_items_form
    <<~STR
    <form action="/" method="post" enctype="application/x-www-form-urlencoded" class="mb-3">
      <div class="form-group">
        <label for="item_name_main">Добавь план на день</label>
        <input type="text" class="form-control" id="item_name_main" name="item_name" placeholder="Писать сюда...">
      </div>
      <button type="submit" class="btn btn-primary btn-sm">Добавить</button>
    </form>
    STR
  end

  def render_item_list(item)
    <<~STR
    <li class="list-group-item">
      <div class="row">
        <div class="col-sm-8">
          <p>#{item[:item_name]}</p>
        </div>
        <div class="col-sm-4">
          <form action="/delete" method="post" enctype="application/x-www-form-urlencoded">
            <input type="hidden" name="item_id" value="#{item[:id]}">
            <button class="btn btn-danger btn-sm">Удалить пункт</button>
          </form>
        </div>
      </div>
    </li>
    STR
  end
end
# Application. View layer: END

rack = MyServer.new

loop do
  # Rack layer: START
  client, method_token, target = rack.fetch_data
  # Rack layer: END

  # Action Dispatch layer: START
  action_view = ActionView.new
  # Decide what to respond
  controller, method_name = case [method_token, target]
                            when ["GET", "/"] then [ItemsController, :index]
                            when ["POST", "/"] then [ItemsController, :create]
                            when ["POST", "/delete"] then [ItemsController, :destroy]
                            else [NotFoundController, :index]
                            end

  status_code, response_message = controller.new(client).send(method_name)
  # Action Dispatch layer: START

  # Construct the HTTP request
  http_response = action_view.render_response(status_code, response_message)

  # Return the HTTP response to client
  client.puts(http_response)
  client.close
end
