require 'rubygems'
require 'thor'
require 'thor/group'

class CG < Thor
  include Thor::Actions

  def self.source_root
    File.expand_path('../../templates', __FILE__)    
  end

  no_tasks do

    def output_path
      "../../src/"
    end

    def underscore_name
      singularize(Thor::Util.snake_case(@name))      
    end

    def minus_name
      underscore_name.gsub("_", "-")
    end

    def plural_underscore_name
      pluralize(underscore_name)
    end

    def camelize_name
      Thor::Util.camel_case(underscore_name)
    end

    def plural_camelize_name
      Thor::Util.camel_case(plural_underscore_name)
    end

    def object_name
      singularize(@name)
    end

    def plural_object_name
      pluralize(object_name)
    end

    def generate_chaplin_app
      run("git clone https://github.com/chaplinjs/chaplin-boilerplate.git")
      run("mv chaplin-boilerplate #{output_path}")
    end

    def generate_chaplin_controller
      path = "#{output_path}coffee/controllers/#{underscore_name}_controller.coffee"

      if !File.exists?(path)
        template('chaplin_controller.coffee.erb', path)
      end

      @action_name == 'index' if !@action_name
      append_to_file(path, "\n\n    #{@action_name}: (params) ->\n      # @view = new #{camelize_name}#{Thor::Util.camel_case(@action_name)}View()")
      
      #template('chaplin_controller_spec.coffee.erb', "#{self.output_path}test/controllers/#{underscore_name}_spec.coffee")
    end

    def generate_chaplin_model
      template('chaplin_model.coffee.erb', "#{output_path}coffee/models/#{underscore_name}.coffee")
    end

    def generate_chaplin_view
      template('chaplin_view.coffee.erb', "#{output_path}coffee/views/#{underscore_name}/#{@action_name}_view.coffee")
    end

    def generate_chaplin_template
      template('chaplin_template_index.hbs.erb', "#{output_path}js/templates/#{underscore_name}/#{@action_name}.hbs")
    end

    def add_view_definition_to_controller
      path = "#{output_path}coffee/controllers/#{underscore_name}.coffee"
      @action_name == 'index' if !@action_name

      content = File.binread(path)
      content.gsub!(/$\n^\],.*\(.*\).*->$/) do |match|
        # include file into define block
        match = "\n  'views/#{underscore_name}/#{@action_name}_view'" + match
        # add class variable
        match.gsub!(') ->', '') << ", #{camelize_name}#{Thor::Util.camel_case(@action_name)}View) ->"
      end
      File.open(path, 'wb') { |file| file.write(content) }

    end

    def create_router_entry
      path = "#{output_path}/coffee/routes.coffee"
      if !@action_name || @action_name == 'index'
        append_to_file(path, "\n\n    # #{camelize_name}\n    match '#{minus_name}/index', '#{camelize_name}#index'")
      else
        insert_into_file(path, "\n    match '#{minus_name}/#{@action_name}', '#{camelize_name}##{@action_name}'", :after => "    match '#{minus_name}/index', '#{camelize_name}#index'" )
      end
    end
  end

  desc 'app', 'basic app creation, clones Chaplin Boilerplate from Github'
  def app
    generate_chaplin_app
  end

  desc 'controller NAME ACTION', "Create a Chaplin Controller"
  def controller(name, action_name = 'index')
    @name = name
    @action_name = action_name
    generate_chaplin_controller
    create_router_entry
  end

  desc 'model Name', "Create a Chaplin Model"
  def model(name)
    @name = name
    generate_chaplin_model
  end

  desc 'view CONTROLLER_NAME ACTION', "Create a Chaplin View"
  def view(name, action_name = 'index')
    @name = name
    @action_name = action_name
    generate_chaplin_view
  end

  desc 'hbs_template CONTROLLER_NAME, ACTION', "Create a Chaplin Template"
  def hbs_template(name, action_name = 'index')
    @name = name
    generate_chaplin_template
  end

  desc 'scaffold NAME', "Generate Chaplin Scaffold - Controller, Model, View (index), Template (index)"
  def scaffold(name)
    @name = name
    @action_name = 'index'
    %w{controller model view template}.each { |which| send("generate_chaplin_#{which}") }
    create_router_entry
    add_view_definition_to_controller
  end

  desc 'scaffold_controller NAME ACTION', "Generate Chaplin Scaffold Controller - Controller, View, Template"
  def scaffold_controller(name, action_name = 'index')
    @name = name
    @action_name = action_name
    %w{controller view template}.each { |which| send("generate_chaplin_#{which}") }
    create_router_entry
    add_view_definition_to_controller
  end

  private
  def pluralize(string)
    singularize(string) + 's'
  end

  def singularize(string)
    string.gsub(%r{s$}, '')
  end
end