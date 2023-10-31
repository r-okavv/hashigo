class OauthsController < ApplicationController
  skip_before_action :require_login
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to root_path, notice: 'ログインをキャンセルしました'
      return
    end
    if (@user = login_from(provider))
      redirect_to search_restaurants_path, notice:"#{provider.titleize}アカウントでログインしました"
    else
      begin
        create_user_and_login_from(provider)
        redirect_to search_restaurants_path, notice:"#{provider.titleize}アカウントでログインしました"
      rescue ActiveRecord::RecordNotUnique
        redirect_to root_path, error: "#{provider.titleize}ログインに失敗しました。ご使用のメールアドレスはすでに登録されている可能性があります。"
      rescue
        redirect_to root_path, alert:"#{provider.titleize}アカウントでのログインに失敗しました!"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

  def create_user_and_login_from(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
  end
end
