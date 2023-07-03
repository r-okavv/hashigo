class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to login_path, success: 'Logged in'
        else
            flash.now[danger] = 'Login failed'
            render :new
        end
    end
    
    private
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
