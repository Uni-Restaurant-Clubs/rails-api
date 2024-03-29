class TimeHelpers

  def self.to_human(time=nil, key="default")
    return nil unless time
    #time.strftime("%m/%d/%Y %I:%M%p")
    time.strftime("%a %b #{time.day.ordinalize}, %I:%M%p")
  end

  def self.now
    DateTime.now.in_time_zone
  end

  def self.now_to_human
    self.to_human(self.now)
  end

  def self.keep_time_but_change_timezone(time_string)
    DateTime.parse(time_string).asctime.in_time_zone("America/New_York")
  end
end
