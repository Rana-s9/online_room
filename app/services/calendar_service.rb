require "google/apis/calendar_v3"
require "google/api_client/client_secrets"
require "googleauth"

class CalendarService
  def initialize(user)
    @user = user
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.authorization = user_google_credentials
  end

  def fetch_events(sync_token: nil)
    options = {
      max_results: 20,
      single_events: true,
      order_by: "startTime"
    }

    # 初回は全件取得のため time_min を指定。差分取得時は sync_token を指定。
    if sync_token.present?
      options[:sync_token] = sync_token
    else
      options[:time_min] = Time.now.iso8601
    end

    response = @service.list_events("primary", **options)
    response
  end

  def calendar_id
    "primary"
  end

  private

  def user_google_credentials
    Google::Auth::UserRefreshCredentials.new(
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      access_token: @user.google_token,
      refresh_token: @user.google_refresh_token,
      expires_at: @user.token_expires_at,
      scope: [ "https://www.googleapis.com/auth/calendar.events" ],
      additional_parameters: { "access_type" => "offline" }
    )
  end
end
