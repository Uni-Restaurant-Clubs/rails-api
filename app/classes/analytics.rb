class Analytics

  def self.track(event_name, options={})

    event_data = {
      user_id: options[:user_id],
      creator_id: options[:creator_id],
      restaurant: options[:restaurant_id],
      event_name: event_name,
      label: options[:label],
      category: options[:category],
      properties: options[:properties]
    }

    event = LogEvent.new(event_data)

    if !event.save
      Airbrake.notify("could not save log event", {
        errors: event.errors.full_messages
      })
      return false
    end
    return true
  end

  def self.page_view(page_name, options)
    options[:label] = page_name
    self.track("Page View", options)
  end
end
