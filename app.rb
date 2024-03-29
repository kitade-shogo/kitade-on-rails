require 'yaml'
# 1.File.dirname(__FILE__)　/home/user/myapp/app.rb　-> /home/user/myapp
# 2.File.join(..., 'app', 'routes.yml') /home/user/myapp -> /home/user/myapp/app/routes.yml
# 3.File.read(...) 指定されたファイルの内容を文字列として読み込む
# 4. YAML.load(...) YAML形式の文字列をRubyのオブジェクトに変換
ROUTES = YAML.load(File.read(File.join(File.dirname(__FILE__), 'app', 'routes.yml')))

require 'sequel'

db_config_file = File.join(File.dirname(__FILE__), 'app', 'database.yml')
if File.exist?(db_config_file)
    config = YAML.load(File.read(db_config_file))
    DB = Sequel.connect(config)
    Sequel.extension :migration
end

# Dir[]でパターンにマッチするファイル名を文字列の配列として返します。
Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }

if DB
    Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), 'app', 'db', 'migrations'))
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each {|file| require file }

class App
    attr_reader :router

    def initialize
        @router = Router.new(ROUTES)
    end

    def call(env)
        result = router.resolve(env)
        [result.status, result.headers, result.content]
    end

    def self.root
        File.dirname(__FILE__)
    end
end