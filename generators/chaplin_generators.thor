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
      Thor::Util.snake_case(plural_underscore_name)
    end

    def object_name
      singularize(@name)
    end

    def plural_object_name
      pluralize(object_name)
    end

    def generate_chaplin_controller
      template('chaplin_controller.coffee.erb', "../../src/coffee/controllers/#{underscore_name}.coffee")
      template('chaplin_controller_spec.coffee.erb', "../../src/test/controllers/#{underscore_name}_spec.coffee")
    end

  end


   desc 'controller Name', "Create a controller"
   def controller(name)
     @name = name
     generate_chaplin_controller
   end


  private
  def pluralize(string)
    singularize(string) + 's'
  end

  def singularize(string)
    string.gsub(%r{s$}, '')
  end
end