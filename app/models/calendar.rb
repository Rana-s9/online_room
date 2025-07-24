class Calendar < ApplicationRecord
  before_validation :adjust_all_day_times

  belongs_to :user
  belongs_to :room

  validates :start_time, presence: true
  validates :end_time, presence: true

  enum schedule_type: { all_day: 0, timed: 1 }
  enum source: { manual: 0, google: 1 }
  enum visibility: { personal: 0, share_only: 1, together: 2 }
  enum category: { relax: 0, work_study: 1, event: 2 }

  def display_start_time
    if schedule_type == "all_day"
      start_time.strftime("%Y-%m-%d")
    else
      start_time.strftime("%Y-%m-%d %H:%M")
    end
  end

  def display_end_time
    return nil if schedule_type == "all_day" && start_time.to_date == end_time.to_date

    if schedule_type == "all_day"
      end_time.strftime("%Y-%m-%d")
    else
      end_time.strftime("%Y-%m-%d %H:%M")
    end
  end

  def all_day?
    schedule_type == "all_day"
  end

  private

  def adjust_all_day_times
    return unless all_day?

    if start_time.present?
      self.start_time = start_time.beginning_of_day
    end

    if end_time.present?
      self.end_time = end_time.end_of_day
    end
  end
end
