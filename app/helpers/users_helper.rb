module UsersHelper
  def last_seen_text(user)
    return t("views.user.status.online") if user.online?
    return t("views.user.status.offline") unless user.last_seen_at

    time = time_ago_in_words(user.last_seen_at)
    t("views.user.status.went_out_ago", time: time)
  end
end
