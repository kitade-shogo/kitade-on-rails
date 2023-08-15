require 'yaml'
ROUTES = YAML.load(File.read(File.json(File.dirname(_FILE_), 'app', 'routes.yml')))

require './lib/router'

class App
    attr_reader :router

    def initialize
        @router = Router.new(ROUTES)
    end
    
    def call(env)
        [200, {}, ['Hello World']]
    end
end