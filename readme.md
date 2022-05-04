
MiniRails - Ruby on MiniRails.

# About

It's my sabbatical project. After catching burnout I decided to resign and take long vacation. Once I watched Maple Ong's talk [Building a Ruby web app using the Ruby Standard Library](https://www.youtube.com/watch?v=lxczDssLYKA) on Euruko 2021. Her talk inspired me.

Firstly, I wrote the same script, it's [here](script.rb). Then I started to improve the script and decided to write an MVC-framework like RubyOnRails on plain Ruby. Such a good challenge.

# Dependencies

The project isn't written on plain Ruby. I use `rack` because it's a standard web server interface for Ruby. Also it has dependency on `puma`, and `rack-test` for testing.

# Features

Features of MiniRails

* Rack-server to handle requests.
* MiniActionController - module for controller layer in MVC structure. It supports: `before_action` callback, `params`-object, setting layout for views,  `rescue_from` rescue handle and `redirect_to`.
* MiniActionDispatch - namespace for rack middlewares. Middlewares are:
  * `AssetHandler` - middleware to distribute stylesheets and javascript files from the `assets` folder.
  * `StaticHandler` - middleware to distribute any files from `public` folder.
  * `RequestHandler` - main middleware to receive rack-request and build response. It supports get/post/delete/put/patch requests.
* MiniActionParams - class to parse http-headers and store params. Similar to `ActionController::Parameters`
* MiniActionView - module for view layer in MVC structure. The layer is separated from `MiniActionController` module. Features:
  * HTML and JSON responses.
  * HTML.ERB views rendering.
  * Partial views and layout rendering.
  * CSS and JS assets rendering.
  * View caching.
* MiniActiveRecord - module for model layer in MVC structure.
List of features:
  * Attribute definition in a model
  * `has_many` and `belongs_to` associations
  * Base abstract driver class for implemening data manipulation for different DBs.
  * Single file storage - yaml_driver
  * CRUD operations for data manipulation
  * Proxy object for quering with chain methods.
  * Scope definition on a model class
  * Data serialisation to JSON
  * Validations `validates_presence_of` and `validates_length_of`
* MiniActiveRouter - module to draw routes map. Features: placeholders for params, not found route for 404 page.
* MiniActiveSupport - a bunch of extensions for different classes. It's similar to ActiveSupport
* MiniCodeLoader - class for code-reloading. It's actual when you are working with CLI console.
* CLI - with CLI you can run web-server, console, tests and create a new application.
* MiniRspec - it's `RSpec` from scratch. It supports RSpec's basic structure: `describe`, `context`, `it`. Also has callback `before_each` and function `let!` to define a helper methods. You can write unit and request tests.
* MiniFactory - it's a copy from `FactoryBot`. Features: factory definition, `sequence` and `trait`.

# Applications

There are two application to present how the framework works: TODO list and Secret app.

## TODO list

You can see the application in [todo_list](todo_list/readme.md) folder

## Secret app

You can see the application in [secret_app](secret_app/readme.md) folder

# How to start

```bash
# Clone the project
git clone git@github.com:kopylovvlad/mini_rails.git
# Install dependencies
cd mini_rails
bundle install
# Return back
cd ../
```

# How to run first app

```bash
# Switch to application folder
cd todo_list
# Install dependencies
bundle install

# Run the server
./bin/mini_rails server
# Open http://0.0.0.0:9292 in a browser

# Run the console
./bin/mini_rails console

# Run the tests
./bin/mini_rails test
```

# How to create new app

```bash
# Create new app
./mini_rails/bin/mini_rails new <NEW_APP_NAME>
# Done! Your application in '/Users/vladislavkopylov/Documents/ruby_scripts/maple_ong/ruby_web2/<NEW_APP_NAME>' folder

# Switch to folder
cd <NEW_APP_NAME>
bundle install

# Run the server
./bin/mini_rails server
# Open http://0.0.0.0:9292 in a browser
# Now, you can write your own application
```


# TODO:

The project is still under development. There is a huge field for improvements.

* MiniActioView: Implement handlers for <form> such as: form_with, form.label, etc
* MiniActioView: Implement handles for quick link creation
