class Router
    attr_reader :routes

    def initialize(routes)
        @routes = routes 
    end 

    def resolve(env)
        # アクセスしたURlのパス取得
        path = env['REQUEST_PATH']
        # routes内にpathというキーを持つものがあるかないかで場合分け
        if routes.key?(path)
            # pathを受け取り、それに対応するコントローラをの新しいインスタンスを返す
            ctrl(routes[path]).call
        else
            Controller.new.not_found
        end
        rescue Exception => error
            puts error.message
            puts error.backtrace
            Controller.new.internal_error
    end

    private

    # 
    def ctrl(string)
        # コントローラ名とアクション名に分割
        ctrl_name,action_name = string.split('#')
        # コントローラの名前を大文字化して、それに対する定数を返す
        klass = Object.const_get("#{ctrl_name.capitalize}Controller")
        # コントローラとアクション名から新しいオブジェクトを生成
        klass.new(name: ctrl_name, action: action_name.to_sym)
    end
end