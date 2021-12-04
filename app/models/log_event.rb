class LogEvent < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :restaurant, optional: true

  validates  :event_name, presence: true

  serialize :properties, Hash

  scope :between_range, -> (start_time, end_time) do
    where(created_at: [start_time..end_time])
  end

  scope :page_views, -> { where(event_name: "Page View") }
  scope :grouped_by_label, lambda {
    group_by do |x|
        x.label
    end
  }
  scope :grouped_by_day, lambda {
    group_by do |x|
        x.created_at.strftime("%Y-%m-%d")
    end
  }

end
