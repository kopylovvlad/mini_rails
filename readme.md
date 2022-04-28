https://gist.github.com/kopylovvlad/6727e8316db553577391ed72dca87f95

https://rubyapi.org/3.1/o/module#method-i-module_exec
https://apidock.com/rails/Class/class_attribute
https://guides.rubyonrails.org/routing.html

Proof of Work version from scratch

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

Добавить:

* Write readme.md
* Implement handlers for <form> such as: form_with, form.label, etc
* Implement handles for quick link creating
* Выложить парням с пометкой PS ищу работу!
