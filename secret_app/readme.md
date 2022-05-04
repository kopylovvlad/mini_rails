# Secret messages application

Example of an application using MiniRails. The app to share secret messages.

## How to start

```bash
# Install all gems
bundle install

# Run the server
./bin/mini_rails server
# Open http://0.0.0.0:9292 in a browser

# Run the console
./bin/mini_rails console

# Run the tests
./bin/mini_rails test
```

## File structure

The file structure is similar to RubyOnRails.

```
.
├── app
│   ├── assets # Folder with assets
│   │   ├── javascript
│   │   └── stylesheets
│   ├── controllers # Controller layer
│   ├── decorators
│   ├── models
│   ├── serializers
│   └── views
├── config
│   ├── application.rb
│   └── router.rb # Routes are here
├── config.ru
├── db # Here are YAML files with data
├── lib # Folder for some code
├── public # Folder for public static files
├── readme.md
└── spec
    ├── factories # Folder with Factories
    ├── models # Folder with unit tests
    └── requests # Folder with requests tets
```

## Features

* Client side logic written on JS
* HTML and JSON responses
* Hide data with password
* Views counter
