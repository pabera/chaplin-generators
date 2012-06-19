Chaplin Generators
==================

These generators are made to work with [Chaplin](https://github.com/chaplinjs/chaplin), an application architecture on top of [Backbone](https://github.com/documentcloud/backbone). 

Using [thor](https://github.com/wycats/thor), it works like normal Rails generators. Currently it only works at a certain application architecture, please be aware of that. The generation is based on the current [Chaplin-Boilerplate](https://github.com/chaplinjs/chaplin-boilerplate) application. Since Chaplin is basically written in Coffeescript, the generators will also generate CoffeeScript files.

The current configuration works with the following application scaffold

```
$ mkdir project && cd project

$ git clone https://github.com/chaplinjs/chaplin-boilerplate.git
$ mv chaplin-boilerplate src

$ git clone https://github.com/pabera/chaplin-generators.git
```

## Scaffold
A scaffold creates a Controller, Model, View (*.coffee) and a template (*.hbs - Handlebars-Template)

`thor chaplin_generator:scaffold NAME`


## Controller
Creates a single controller (*.coffee)

`thor chaplin_generator:controller NAME`


## Model
Creates a single model (*.coffee)

`thor chaplin_generator:model NAME`


## View
Creates a single view (*.coffee)

`thor chaplin_generator:view NAME`


## Template
Creates a single Handlebars Template (*.js)

`thor chaplin_generator:hbs_template NAME`