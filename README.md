## Exploration

From [Hartl - Chapter 3: Mostly static pages](https://www.railstutorial.org/book/static_pages)

## Exposition

Not all controllers use RESTful actions. Sometimes they are not always the best solution. An example would be when setting up static pages such as your home, help, about  and contact pages.

Therefore instead of running `rails generate scaffold` we would run `rails generate controller` instead:

```
rails generate controller StaticPages home contact
```

### Tests

Use `rails test` to run a test suite. Gems involved in runing a test suite:
* spring
* guard

#### Writing tests for your controller file

Writing a test for your controller file, located at `./test/controllers/controller_pluralname_controller_test.rb` looks like this:

```ruby
test "string description of test" do
  http_method controller_pluralname_action_url
  assert_response :http_response_phrase
end
```

* The `string description` is short and involves the http method and the controller action.
* The `http_method` is can be either a `get`, `post`, `put` and `delete` verb.
* The `controller_pluralname` refers to the controller being referred to.
* The `action` is the name of the action the http request is routed to.
* The `assert_response` method is accepting a http response as an argument - it seems to be able to accept the response phrase too.

For example:

```ruby
test "should get about" do
  get static_pages_about_url
  assert_response :success
end
```

When the test is first run, a **route** issue is identified:

* `Name Error: undefined local variable or method 'static_pages_about_url'`

Which is fixed by adding:

```ruby
# ./config/routes.rb

get `static_pages/about`
```

When the test is run again, a **controller** issue is identified:

* `AbstractController:ActionNotFound: the action 'about' could not be found for StaticPagesController`

Which is fixed by adding:

```ruby
# ./app/controllers/static_pages_controller.rb

def about
end
```

When the test is again, a **view** issue is identified:

* `ActionController::UnknownFormat: StaticPagesController#about is missing a template for this request format and variant`

Which is fixed by writing the terminal command:

```
touch app/views/static_pages/about.html.erb
```

#### Assert Response | Assert Select

The first assert, `assert_response`, is a method that tests for the contents of the http response. The following assert, `assert_select`, is a method that tests for the presence of a HTML element and its contents. This is pretty cool because it means you are able to write a test not only for Ruby logic - regarding the MVC architecture - but for HTML content as well.

In following example, the first argument is the `"title"` element that is found within the `<head>` tag (where all the metadata is stored - it comes before the body and is not to be confused with `<header>` or `<h1>`. The second argument that follows is a string representing the contents of the element: `"Home | Ruby on Rails Tutorial Sample App"`:

```ruby
# ./test/controllers/static_pages_controller_test.rb
test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | Ruby on Rails Tutorial Sample App"
  end
```

#### Refactoring tests with the 'setup' method:

Later the tests can be refactored using a `setup` method which is run automatically before every test. The setup method acts very much like a `before { }` hook within RSpec:

```ruby
# ./test/controllers/static_pages_controller_test.rb

def setup
  @base_title = "Ruby on Rails Tutorial Sample App"
end

test "should get home" do
  get static_pages_home_url
  assert_response :success
  assert_select "title", "Home | #{@base_title}"
end
```

### Another way to use yield

When `<%= yield %>` is used within a template file, this plugs in all the content within a view file inside. However a special **yield partial thingy** is also possible with the `provide` method.

```html
<!-- .app/views/static_pages/home.html.erb -->
<% provide(:title, "Home") %>
```

```html
<!-- .app/views/layouts/application.html.erb -->
<title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
```

## Excursion

Important rail commands to know:

```
rails generate scaffold Resource parameter1:data_type1 parameter2:data_type2


rails generate controller Resource action1 action2

rails destroy controller Resource action1 action 2


rails db:migrate

rails db:rollback

rails db:migrate VERSION=0
```

## Eggs

* Q: Generate a controller called Foo with actions bar and baz.
* A: `rails generate controller Foo bar baz`

* Q: Destroy the Foo controller and its associated actions. 
* A: `rails destroy controller Foo bar baz`

---

* Q: The base title, “Ruby on Rails Tutorial Sample App”, is the same for every title test. Using the special function setup, which is automatically run before every test, verify that the tests are still GREEN.
* A:

```ruby
# ./test/controllers/static_pages_controller_test.rb

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    .
  end

  test "should get about" do
    .
  end
end
```

---

* Q: Make a Contact page for the sample app. First write a test for the existence of a page at the URL /static_pages/contact by testing for the title “Contact | Ruby on Rails Tutorial Sample App”. Get your test.
* A: 

```ruby
# ./test/controller/static_pages_controller_test.rb

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get contact" do
    get static_pages_contact_url
    assert_response : success
  end
end
```

```ruby
# ./config/routes.rb

Rails.application.routes.draw do
  get 'static_pages/contact'
end
```

```ruby
# ./app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  def contact
  end
end
```

`touch app/views/static_pages/contact.html.erb`

---

* Q: Adding a root route leads to the creation of a Rails helper called `root_url`. Write a test for the root route.  
* A:

```ruby
# ./test/controllers/static_pages_controller_test.rb

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response assert_response
  end
end
```
