require 'rubygems'
require 'thor'
require 'thor/group'

class ChaplinGenerator < Thor

  include Thor::Actions

  def self.source_root
    File.expand_path('../../templates', __FILE__)    
  end

  no_tasks do

    def underscore_name
      singularize(Thor::Util.snake_case(@name))      
    end

    def plural_underscore_name
      pluralize(underscore_name)
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

    def generate_chaplin_controller
      template('chaplin_controller.coffee.erb', "../../src/coffee/controllers/#{underscore_name}.coffee")
      #template('chaplin_controller_spec.coffee.erb', "../../src/test/controllers/#{underscore_name}_spec.coffee")
    end

    def generate_chaplin_view
      template('chaplin_view.coffee.erb', "../../src/coffee/views/#{underscore_name}/index_view.coffee")
      #template('chaplin_controller_spec.coffee.erb', "../../src/test/views/#{underscore_name}/index_view_spec.coffee")
    end

    def generate_chaplin_template
      template('chaplin_template_index.hbs.erb', "../../src/js/templates/#{underscore_name}/index.hbs")
    end
  end


  desc 'controller Name', "Create a controller"
  def controller(name)
    @name = name
    generate_chaplin_controller
  end

  desc 'view Name', "Create a View"
  def view(name)
    @name = name
    generate_chaplin_view
  end

  desc 'hbs_template Name', "Create a Template"
  def hbs_template(name)
    @name = name
    generate_chaplin_template
  end

  desc 'scaffold Name', "Generate Scaffold"
  def scaffold(name)
    @name = name
    %w{controller view template}.each { |which| send("generate_chaplin_#{which}") }
  end

  private
  def pluralize(string)
    singularize(string) + 's'
  end

  def singularize(string)
    string.gsub(%r{s$}, '')
  end
end