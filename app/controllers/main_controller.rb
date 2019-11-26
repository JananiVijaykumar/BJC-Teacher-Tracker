class MainController < ApplicationController
    def index
        @teacher = Teacher.new
    end

    def dashboard
        @items = [
            {
                'long': 39,
                'lat': -95,
            },
            {
                'long': 37,
                'lat': -92,
            }
        ]
    end
end