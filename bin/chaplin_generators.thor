require 'rubygems'
require 'thor'
require 'thor/group'

class CG < Thor
  include Thor::Actions

  def self.source_root
    File.expand_path('../../templates', __FILE__)    
  end

  no_tasks do

    def src_path
      "../../src"
    end

    def test_path
      "../../test"
    end

    def underscore_name
      name = @name.gsub("-", "_")
      singularize(Thor::Util.snake_case(name))
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
      if !File.exists?(src_path)
        run("git clone https://github.com/pabera/chaplin-boilerplate.git")
        run("mv chaplin-boilerplate #{src_path}")

        path = "#{src_path}/coffee/hello_world_application.coffee"
 
        content = File.binread(path)
        content.gsub!(/HelloWorldApplication/, "#{camelize_name}Application") # add new application file as class
        content.gsub!(/Chaplin Example Application/, "#{camelize_name}Application")
        File.open(path, 'wb') { |file| file.write(content) }
 
        run("mv #{path} #{src_path}/coffee/#{underscore_name}_application.coffee") # rename application file

        say "Please note that several 'Hello World' files have been kept in various folders, feel free to remove them."
      else
        say "Application directory already exists!"
      end
    end

    def generate_chaplin_app_tests
      if !File.exists?(test_path)
        run("git clone https://github.com/pabera/chaplin-mocha.git")
        run("mv chaplin-mocha/test #{test_path}")
        remove_file("#{test_path}/coffee/hello_world_application_spec.coffee") # delete hello_world from cloned repo
        run("rm -rf chaplin-mocha")

        # Update config.js file
        path = "#{test_path}/config.js"
        content = File.binread(path)
        content.gsub!(/hello_world/, "#{underscore_name}")
        File.open(path, 'wb') { |file| file.write(content) }

        template("test/application_spec.coffee.erb", "#{test_path}/coffee/#{underscore_name}_application_spec.coffee")
      else
        say "Test directory already exists!"
      end
    end

    def generate_chaplin_controller
      path = "#{src_path}/coffee/controllers/#{underscore_name}_controller.coffee"

      if !File.exists?(path)
        template('src/chaplin_controller.coffee.erb', path)
      end

      view_name = 'view' 
      if !@action_name
        @action_name == 'index'
      else
        view_name = "#{@action_name}_view"
      end

      append_to_file(path, "\n\n    # #{@action_name}: (params) ->\n    #   @#{@action_name}_view = new #{camelize_name}#{Thor::Util.camel_case(@action_name)}View()")
    end

    def generate_chaplin_controller_tests
      @type = "controller"
      if test_environment!
        path = "#{test_path}/coffee/controllers/#{underscore_name}_controller_spec.coffee"

        if !File.exists?(path)
          template("test/controller_spec.coffee.erb", path)
          create_test_entry
        end

        # Add default action tests to existing Spec File
        @action_name == 'index' if !@action_name
        append_to_file(path, "\n\n    describe '@#{@action_name}', ->

      it 'should have a #{@action_name} function', ->
        expect(@#{camelize_name}Controller.#{@action_name}).to.be.a('function')")

      else
        say "Skipped tests"
      end
    end

    def generate_chaplin_model
      path = "#{src_path}/coffee/models/#{underscore_name}.coffee"

      if !File.exists?(path)
        template('src/chaplin_model.coffee.erb', path)
      end
    end

    def generate_chaplin_model_tests
      @type = "model"
      if test_environment!
        template('test/model_spec.coffee.erb', "#{test_path}/coffee/models/#{underscore_name}_model_spec.coffee")
        create_test_entry
      else
        say "Skipped tests"
      end
    end

    def generate_chaplin_view
      path = "#{src_path}/coffee/views/#{underscore_name}/#{@action_name}_view.coffee"

      if !File.exists?(path)
        template('src/chaplin_view.coffee.erb', path)
      end
    end

    def generate_chaplin_view_tests
      @type = "view"
      if test_environment!
        path = "#{test_path}/coffee/views/#{underscore_name}_view_spec.coffee"

        if !File.exists?(path)
          template('test/view_spec.coffee.erb', path)
          create_test_entry
        end

        # Add default action tests to existing Spec File
        @action_name == 'index' if !@action_name
        append_to_file(path, "\n\n  describe 'Views/#{camelize_name}/#{Thor::Util.camel_case(@action_name)}View', ->

    beforeEach ->
      @#{camelize_name}#{Thor::Util.camel_case(@action_name)}View = new #{camelize_name}#{Thor::Util.camel_case(@action_name)}View()

    it 'should have a set container class', ->
      @#{camelize_name}#{Thor::Util.camel_case(@action_name)}View.container.should.be.a('string')
      expect(@#{camelize_name}#{Thor::Util.camel_case(@action_name)}View.container).to.not.equal('')

    describe '@initialize', ->

      it 'should be defined', ->
        expect(@#{camelize_name}#{Thor::Util.camel_case(@action_name)}View.initialize()).to.be.an('object')")

        # add require to decline
        add_view_definition path, @action_name

      else
        say "Skipped tests"
      end
    end

    def generate_chaplin_template
      template('src/chaplin_template_index.haml.erb', "#{src_path}/coffee/templates/#{underscore_name}/#{@action_name}.haml")
    end

    def add_view_definition(path, action_name)
      content = File.binread(path)
      content.gsub!(/$\n^\],.*\(.*\).*->$/) do |match|
        # include file into define block
        match = "\n  'views/#{underscore_name}/#{action_name}_view'" + match
        # add class variable
        match.gsub!(') ->', '') << ", #{camelize_name}#{Thor::Util.camel_case(action_name)}View) ->"
      end
      File.open(path, 'wb') { |file| file.write(content) }
    end

    # TODO: When there is not index route, it is not possible to add other routes at the moment!
    def create_router_entry
      path = "#{src_path}/coffee/routes.coffee"
      if !@action_name || @action_name == 'index'
        append_to_file(path, "\n\n    # #{camelize_name}\n    match '#{pluralize(minus_name)}', '#{camelize_name}#index'")
      else
        insert_into_file(path, "\n    match '#{pluralize(minus_name)}/#{@action_name}', '#{camelize_name}##{@action_name}'", :after => "    match '#{pluralize(minus_name)}', '#{camelize_name}#index'" )
      end
    end

    def create_test_entry
      path = "#{test_path}/config.js"

      content = File.binread(path)
      content.gsub!(/$\n.*\],.*\n*.*\n*.*mocha.run\(\)$/) do |match|
        # include file into define block
        match = ",\n    '../../test/js/#{@type}s/#{underscore_name}_#{@type}_spec'" + match
      end
      File.open(path, 'wb') { |file| file.write(content) }
    end

    def test_environment!
      File.exists?("#{test_path}")
    end
  end

  desc 'app NAME', 'basic app creation, clones Chaplin Boilerplate from Github'
  method_options :skip_tests => :boolean
  def app(name)
    @name = name
    generate_chaplin_app
    generate_chaplin_app_tests unless options.skip_tests
  end

  desc 'controller NAME ACTION', "Create a Chaplin Controller"
  method_options :skip_routing => :boolean, :skip_tests => :boolean
  def controller(name, action_name = 'index')
    @name = name
    @action_name = action_name
    generate_chaplin_controller
    generate_chaplin_controller_tests unless options.skip_tests
    create_router_entry unless options.skip_routing
  end

  desc 'model Name', "Create a Chaplin Model"
  method_options :skip_tests => :boolean
  def model(name)
    @name = name
    generate_chaplin_model
    generate_chaplin_model_tests unless options.skip_tests
  end

  desc 'view CONTROLLER_NAME ACTION', "Create a Chaplin View"
  method_options :skip_tests => :boolean
  def view(name, action_name = 'index')
    @name = name
    @action_name = action_name
    generate_chaplin_view
    generate_chaplin_view_tests unless options.skip_tests
  end

  desc 'hbs_template CONTROLLER_NAME, ACTION', "Create a Chaplin Template"
  def hbs_template(name, action_name = 'index')
    @name = name
    generate_chaplin_template
  end

  desc 'scaffold NAME', "Generate Chaplin Scaffold - Controller, Model, View (index), Template (index)"
  method_options :skip_routing => :boolean, :skip_tests => :boolean
  def scaffold(name)
    @name = name
    @action_name = 'index'
    %w{controller model view template}.each { |which| send("generate_chaplin_#{which}") }
    %w{controller model view}.each { |which| send("generate_chaplin_#{which}_tests") } unless options.skip_tests
    create_router_entry unless options.skip_routing

    path = "#{src_path}/coffee/controllers/#{underscore_name}_controller.coffee"
    @action_name == 'index' if !@action_name
    add_view_definition path, @action_name
  end

  desc 'scaffold_controller NAME ACTION', "Generate Chaplin Scaffold Controller - Controller, View, Template"
  method_options :skip_routing => :boolean, :skip_tests => :boolean
  def scaffold_controller(name, action_name = 'index')
    @name = name
    @action_name = action_name
    %w{controller view template}.each { |which| send("generate_chaplin_#{which}") }
    %w{controller view}.each { |which| send("generate_chaplin_#{which}_tests") } unless options.skip_tests
    
    create_router_entry unless options.skip_routing

    path = "#{src_path}/coffee/controllers/#{underscore_name}_controller.coffee"
    @action_name == 'index' if !@action_name
    add_view_definition path, @action_name
  end

  private
  def pluralize(string)
    singularize(string) + 's'
  end

  def singularize(string)
    string.gsub(%r{s$}, '')
  end
end