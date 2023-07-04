class UserSessionsController < ApplicationController
  def new; end
  
  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to root_path
    else
      flash.now[:danger] = 'Login failed'
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_user_path
  end
end
