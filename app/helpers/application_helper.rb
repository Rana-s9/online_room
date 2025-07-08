module ApplicationHelper
  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  def default_meta_tags
    {
      site: "Online Room",
      title: "遠くにいる人と、日常を一緒に過ごすアプリ",
      reverse: true,
      charset: "utf-8",
      description: "Online Roomでは、遠くにいる人や会えない人と日々の記録を共有し、同じ部屋に帰宅する体験ができます。",
      keywords: "遠距離恋愛,友人,家族,オンライン,交換日記,心身の記録,天気共有",
      canonical: "https://our-onlineroom.com/",
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "https://our-onlineroom.com/?t=refresh",
        image: "https://our-onlineroom.com/images/ogp.png",
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@rana101779s",
        image: "https://our-onlineroom.com/images/ogp.png"
      }
    }
  end
end
