class Analytics

  def self.track(event_name, options={})

    if !options[:restaurant_id] && options[:feature_period_id]
      feature = FeaturePeriod.find_by(id: options[:feature_period_id])
      options[:restaurant_id] = feature.restaurant&.id
    end

    event_data = {
      feature_period_id: options[:feature_period_id],
      user_id: options[:user_id],
      user_ip_address: options[:user_ip_address],
      content_creator_id: options[:creator_id],
      restaurant_id: options[:restaurant_id],
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
