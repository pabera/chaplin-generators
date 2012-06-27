Chaplin Generators
==================

These generators are made to work with [Chaplin](https://github.com/chaplinjs/chaplin), an application architecture on top of [Backbone](https://github.com/documentcloud/backbone). 

Using [thor](https://github.com/wycats/thor), they have the look and feel like normal Rails generators. Currently it only works at a certain application architecture, please be aware of that. The generation is based on the current [Chaplin-Boilerplate](https://github.com/chaplinjs/chaplin-boilerplate) application. Since Chaplin is basically written in Coffeescript, the generators will also generate CoffeeScript files.

The current configuration works with the following application scaffold. The generators are using 2-Spaces indentation!

```
$ mkdir project && cd project
$ git clone https://github.com/pabera/chaplin-generators.git
$ cd chaplin-generators/bin
```

### Convention over Configuration
Since this paradigm is all present in Rails it was almost necessary to follow it too. But since Rails uses a lot of logic (e.g. grammatically) I thought I need to stick with some basics. I will add the naming convention example to every generator listed below.

*Please note: always provide singular words as identifiers (NAME) since the generator e.g. simply adds an 's' to it several times to indicate plural words.*

### Application
Clones the Chaplin-Boilerplate from Github and sets up folder structure that works with chaplin-generators

`thor cg:app NAME`

```
$ thor cg:app test
Creates a TestApplication
```

### Scaffolds
A scaffold creates a Controller, Model, View (.coffee) and a template (.hbs - Handlebars-Template)

`thor cg:scaffold NAME (--skip_tests)`

```
$ thor cg:scaffold foo

Creates: 

Source
* Controller: src/coffee/controllers/foo_controller.coffee    -> FooController() and appends a @index action
* Model:      src/coffee/models/foo.coffee                    -> Foo()
* View:       src/coffee/views/foo/index_view                 -> FooIndexView()
* Template:   src/js/templates/foo/index.hbs
* Route:      in case of 'index'                              -> match 'foos', 'Foo#index'
              in any other case 'bar'                         -> match 'foos/bar' -> 'Foo#bar'

Tests
* Controller: test/coffee/controllers/foo_controller_spec.coffee  -> new actions will be added automatically
* Model:      test/coffee/models/foo_model_spec.coffee
* View:       test/coffee/views/foo_view_spec.coffee              -> new views in the 'foo' namespace will be added to this file
```

### Controllers
Creates a new single controller (*.coffee)

`thor cg:controller NAME (--skip_routing, --skip_tests)`

Create a new controller action

`thor cg:controller NAME ACTION (--skip_routing, --skip_tests)`

`thor cg:scaffold_controller NAME ACTION (--skip_routing, --skip_tests)`

This task creates a Controller, a View (.coffee) and a template (.hbs - Handlebars-Template) and if the controller already exists, it adds the important information to it.

`skip_routing` prevents the generator from inserting a new route to the router

### Models
Creates a single model (*.coffee)

`thor cg:model NAME (--skip_tests)`


### Views
Creates a single view (*.coffee)

`thor cg:view NAME (--skip_tests)`


### Templates
Creates a single Handlebars Template (*.hbs)

`thor cg:hbs_template NAME`


#### Overview
```
$ thor list
cg
--
thor cg:app NAME                              # basic app creation, clones Chaplin Boilerplate from Github
thor cg:controller NAME ACTION                # Create a Chaplin Controller
thor cg:hbs_template CONTROLLER_NAME, ACTION  # Create a Chaplin Template
thor cg:model Name                            # Create a Chaplin Model
thor cg:scaffold NAME                         # Generate Chaplin Scaffold - Controller, Model, View (index), Template (index)
thor cg:scaffold_controller NAME ACTION       # Generate Chaplin Scaffold Controller - Controller, View, Template
thor cg:view CONTROLLER_NAME ACTION           # Create a Chaplin View
```