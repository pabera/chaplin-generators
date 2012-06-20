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

### Application
Clones the Chaplin-Boilerplate from Github and sets up folder structure that works with chaplin-generators

`thor cg:app`

### Scaffolds
A scaffold creates a Controller, Model, View (.coffee) and a template (.hbs - Handlebars-Template)

`thor cg:scaffold NAME`

### Controllers
Creates a new single controller (*.coffee)

`thor cg:controller NAME`

Create a new controller action

`thor cg:controller NAME ACTION`

`thor cg:scaffold_controller NAME ACTION`
This task creates a Controller, a View (.coffee) and a template (.hbs - Handlebars-Template) and if the controller already exists, it adds the important information to it.

### Models
Creates a single model (*.coffee)

`thor cg:model NAME`


### Views
Creates a single view (*.coffee)

`thor cg:view NAME`


### Templates
Creates a single Handlebars Template (*.hbs)

`thor cg:hbs_template NAME`


#### Overview
```
$ thor list
cg
--
thor cg:app                       # basic app creation, clones Chaplin Boilerplate from Github
thor cg:controller NAME ACTION    # Create a Chaplin Controller
thor cg:hbs_template Name         # Create a Chaplin Template
thor cg:model Name                # Create a Chaplin Model
thor cg:scaffold Name             # Generate Chaplin Scaffold - Controller, Model, View, Template
thor cg:scaffold_controller Name  # Generate Chaplin Scaffold Controller - Controller, View, Template
thor cg:view Name                 # Create a Chaplin View
```