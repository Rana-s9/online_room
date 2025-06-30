module ApplicationHelper
  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  def default_meta_tags
    {
      site: "Online Room",
      title: "遠くにいる人と部屋を共有できるサービス",
      reverse: true,
      charset: "utf-8",
      description: "Live Fesでは、音楽ライブやフェスの余韻や喪失感を参加者同士で共通し、感想や思い出を語り合うことができます。",
      keywords: "音楽,ライブ,フェス,余韻,喪失感,共有",
      canonical: "https://online-room.onrender.com/",
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "https://online-room.onrender.com/",
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@rana101779s",
        image: image_url("ogp.png")
      }
    }
  end
end
