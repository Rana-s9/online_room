class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2
  def google_oauth2
    auth = request.env["omniauth.auth"]
    @user = User.find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.name = auth.info.name || "No Name"
      user.password = Devise.friendly_token[0, 20]
    end

    @user.update(
      google_token: auth.credentials.token,
      google_refresh_token: auth.credentials.refresh_token.presence || @user.google_refresh_token, # refresh_tokenは再ログインで渡ってこないこともある
      token_expires_at: Time.at(auth.credentials.expires_at)
    )
    if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
        flash[:alert] = @user.errors.full_messages.to_sentence if @user.errors.any?
        redirect_to new_user_registration_url
    end
  end


  def callback_for(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
    else
        session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
        flash[:alert] = @user.errors.full_messages.to_sentence if @user.errors.any?
        redirect_to new_user_registration_url
    end
  end


  def failure
    redirect_to root_path
  end
end
