# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  def github
    upsert_user('GITHUB')
  end

  def yandex
    upsert_user('YANDEX')
  end

  def telegram
    upsert_user('TELEGRAM')
  end

  def firebase
    upsert_user('FIREBASE')
  end

  private

  def upsert_user(provider)
    @user = User.find_for_oauth(auth(request.env['omniauth.auth'] || params))

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end

  def auth(params)
    email    = params.dig(:user, :email).present? ? params.dig(:user, :email) : params.dig(:info, :email)
    uid      = params[:uid]      || params.dig(:user, :uid)
    provider = params[:provider] || params.dig(:user, :provider)
    password = Devise.friendly_token[0, 20]
    {
        uid:      uid,
        provider: provider,
        email:    email || "#{params.dig(:user, :phone) || uid}@#{provider}",
        token:    params.dig(:credentials, :token)      || params[:token],
        name:     params.dig(:extra, :raw_info, :login) || params.dig(:user, :name),
        phone:    params.dig(:user, :phone),
        password: password,
        password_confirmation: password
    }
  end
end
