class OauthsController < ApplicationController
  skip_before_action: :require_login
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to root_path, notice: 'ログインをキャンセルしました'
      return
    end
    if (@user = login_form(provider))
      redirect_to search_restaurants_path, notice:"#{provider.titleize}でログインしました"
    else
      @user = create_form(provider)
      reset_session
      auto_login(@user)
      redirect_to search_restaurants_path, notice:"#{provider.titleize}でログインしました"
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
