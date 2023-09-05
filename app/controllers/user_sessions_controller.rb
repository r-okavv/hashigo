class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to restaurants_path, success: t('.success')
    else
      flash.now[:error] = 'Login failed'
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_user_path
  end
end
