class TimeHelpers

  def self.to_human(time, key="default")
    #time.strftime("%m/%d/%Y %I:%M%p")
    time.strftime("%a %b #{time.day.ordinalize}, %I:%M%p")
  end

  def self.now
    DateTime.now.in_time_zone
  end
end
