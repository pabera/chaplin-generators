Chaplin Generators
==================

These generators are made to work with [Chaplin](https://github.com/chaplinjs/chaplin), an application architecture on top of [Backbone](https://github.com/documentcloud/backbone). 

Using [thor](https://github.com/wycats/thor), they have the look and feel like normal Rails generators. Currently it only works at a certain application architecture, please be aware of that. The generation is based on the current [Chaplin-Boilerplate](https://github.com/chaplinjs/chaplin-boilerplate) application. Since Chaplin is basically written in Coffeescript, the generators will also generate CoffeeScript files.

The current configuration works with the following application scaffold

```
$ mkdir project && cd project

$ git clone https://github.com/chaplinjs/chaplin-boilerplate.git
$ mv chaplin-boilerplate src

$ git clone https://github.com/pabera/chaplin-generators.git
$ cd chaplin-generators/bin
```

### Scaffold
A scaffold creates a Controller, Model, View (*.coffee) and a template (*.hbs - Handlebars-Template)

`thor cg:scaffold NAME`


### Controllers
Creates a single controller (*.coffee)

`thor cg:controller NAME`


### Models
Creates a single model (*.coffee)

`thor cg:model NAME`


### Views
Creates a single view (*.coffee)

`thor cg:view NAME`


### Templates
Creates a single Handlebars Template (*.js)

`thor cg:hbs_template NAME`


#### Overview
```
$ thor list
cg
--
thor cg:controller Name           # Create a Chaplin Controller
thor cg:hbs_template Name         # Create a Chaplin Template
thor cg:model Name                # Create a Chaplin Model
thor cg:scaffold Name             # Generate Chaplin Scaffold - Controller, Model, View, Template
thor cg:scaffold_controller Name  # Generate Chaplin Scaffold Controller - Controller, View, Template
thor cg:view Name                 # Create a Chaplin View
```