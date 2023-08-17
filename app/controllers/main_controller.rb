class MainController < Controller
    def index
        @title = 'MainController#index'
        @arr = %w(one two three)
    end

    def hello
        @hello = 'hello'
    end
end