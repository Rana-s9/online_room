class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_last_seen, if: :user_signed_in?

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    if request.path =~ %r{\A/users/auth/}
      {}
    else
      { locale: I18n.locale }
    end
  end

  protected

  def update_last_seen
    current_user.update_column(:last_seen_at, Time.current)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ]) # ←これがnameの編集に必要！
  end
end
