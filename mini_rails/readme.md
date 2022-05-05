Ruby on MiniRails source code.

# Structure

* dummy_app - template folder to create new application.
* mini_action_controller - the module for controller layer in MVC pattern.
* mini_action_dispatcher - namespace for rack middlewares to handle request and distribute content.
* mini_action_params - data object for client request params.
* mini_action_view - the module for view layer in MVC pattern.
* mini_active_record - the module for model layer in MVC pattern.
* mini_active_router - the module to draw routes map and match route.
* mini_active_support - a bunch of extensions for different classes. It's similar to `ActiveSupport`.
* mini_code_loader - class for code-reloading.
* mini_factory - it's a little copy of `FactoryBot`.
* mini_r_spec - `RSpec` from scratch. It supports RSpec's basic structure and some callbacks.
* mini_rails - main module and entrypoint.

# TODO:

The project is still under development. There is a huge field for improvements.

* MiniActioView: Implement handlers for <form> such as: form_with, form.label, etc
* MiniActioView: Implement handles for quick link creation
