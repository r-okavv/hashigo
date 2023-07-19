class SearchesController < ApplicationController
    def search
        @address = params[:address]
        if @address
            redirect_to result_path
        end
    end

    def result
    end
end
