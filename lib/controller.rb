class Controller
    attr_reader :name, :action
    attr_accessor :status, :headers, :content


    def initialize(name: nil, action: nil)
        @name = name
        @action = action
    end

    def call
        # sendメソッドで動的にメソッドを呼ぶことができる
        send(action)
        self.status = 200
        self.headers = {"content-type" => "text/html"}
        # result(binding)メソッドでレンダリング
        self.content = [templete.result(binding)]
        # selfを返すことでメソッドの呼び出し元にこのコントローラのインスタンスを返す
        self
    end


    def not_found
        self.status = 404
        self.headers = {}
        self.content = ["Nothing found"]
        self
    end

    def internal_error
        self.status = 500
        self.headers = {}
        self.content = ["Internal error"]
        self
    end

    # rootから指定されたERBテンプレートを読み込み、ERBオブジェクトとして初期化
    def templete
        ERB.new(File.read(File.join(App.root, 'app', 'views', "#{self.name}", "#{self.action}.erb")))
    end
end