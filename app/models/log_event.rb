class LogEvent < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  validates  :event_name, presence: true

  serialize :properties, Hash

  scope :between_range, -> (start_time, end_time) do
    where(created_at: [start_time..end_time])
  end

  scope :grouped_by_day, lambda {
    group_by do |x|
        x.created_at.strftime("%Y-%m-%d")
    end
  }

end
