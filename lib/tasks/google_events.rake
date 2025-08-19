namespace :google_events do
  desc "非公開かつ連携日(sync_at)が30日以上前のGoogle Calendarデータを削除する"
  task delete_old: :environment do
    # 削除対象を取得
    old_events = Calendar.where(visibility: :personal, source: :google)
                        .where.not(google_event_id: nil)
                        .where("last_synced_at <= ?", 5.minutes.ago)
                        .select(:id, :room_id, :google_event_id)
                        .pluck(:id)

    puts "削除対象: #{old_events.count} 件"

    old_events.each do |event|
      puts "Event ID: #{event.id}, last_synced_at: #{event.last_synced_at}"
    end

    deleted_count = 0

    # トランザクションで安全に削除
    Calendar.transaction do
        deleted_count = Calendar.where(id: old_events).delete_all
    end
    Rails.logger.info "[CalendarDeleteTask] #{deleted_count} records deleted at #{Time.current}"
  end
end
