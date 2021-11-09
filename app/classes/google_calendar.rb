require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class GoogleCalendar

  Calendar = Google::Apis::CalendarV3
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

  def self.prepare_event_data(restaurant)
    start_time = restaurant.scheduled_review_date_and_time
    return {
      restaurant_name: restaurant.name,
      restaurant_id: restaurant.id,
      address: restaurant.address&.full_address,
      writer: restaurant.writer,
      photographer: restaurant.photographer,
      start_time: start_time,
      end_time: (start_time + 2.hours),
      timezone: "America/New_York",
      methods_and_minutes: self.day_before_and_2_hours_before_reminders,
    }
  end

  def self.create_scheduled_time_confirmed_for_creators(restaurant)
    summary = "URC Restaurant Review for #{restaurant.name}"
    description =
      "<b>Restaurant Info:</b>" +
      "<ul>" +
        "<li>Name: #{restaurant.name}</li>" +
        "<li><a href=\'#{restaurant.yelp_url}\'>Yelp Link</a></li>" +
        "<li>Scheduled date and time: #{TimeHelpers.to_human(restaurant.scheduled_review_date_and_time)}</li>" +
        "<li>Writer: #{restaurant.writer.name}</li>" +
        "<li>Photographer: #{restaurant.photographer.name}</li>" +
      "</ul>"
    description += TextContent.find_by(name: "notify creators that a review has been scheduled")&.text
    start_time = restaurant.scheduled_review_date_and_time
    event_data = self.prepare_event_data(restaurant)
    extra_data = {
      summary: summary,
      description: description,
      emails: [restaurant.writer.email&.strip, restaurant.photographer.email&.strip]
    }
    event_data.merge!(extra_data)
    self.create_event(event_data)
  end

  def self.create_scheduled_time_confirmed_for_restaurant(restaurant)
    restaurant = Restaurant.find_by(id: 3715)
    summary = "Uni Restaurant Club is sending a writer and photographer to review your restaurant!"
    description = TextContent.find_by(name: "notify restaurant that a review has been scheduled")&.text
    start_time = restaurant.scheduled_review_date_and_time
    event_data = self.prepare_event_data(restaurant)
    extra_data = {
      summary: summary,
      description: description,
      emails: restaurant.primary_email&.strip,
    }
    event_data.merge!(extra_data)
    result = self.create_event(event_data)
  end

  def self.create_attendees(emails)
    # protect from notifying real people during development
    emails = ["montylennie@gmail.com"] if Rails.env != "production"
    attendees = []
    emails.each do |email|
      attendees << Calendar::EventAttendee.new(email: email)
    end
    attendees
  end

  def self.day_before_and_2_hours_before_reminders
    return [
      ["email", (24 * 60)],
      ["popup", (24 * 60)],
      ["email", (2 * 60)],
      ["popup", (2 * 60)]
    ]
  end

  # methods and minutes example:
  # [["email", (24 * 60)], ["popup", 10]]
  def self.create_notifications(methods_and_minutes)
    notifications = []
    methods_and_minutes.each do |data|
      notifications << Calendar::EventReminder.new(
        reminder_method: data[0],
        minutes: data[1]
      )
    end
    notifications
  end

  def self.create_calendar_and_authorize
    calendar = Calendar::CalendarService.new
		scopes =  ['https://www.googleapis.com/auth/calendar',
               'https://www.googleapis.com/auth/gmail.send',
               'https://www.googleapis.com/auth/calendar.events',
               "https://www.googleapis.com/auth/admin.directory.resource.calendar"]
    calendar.authorization = Google::Auth::ServiceAccountCredentials.from_env(scope: scopes)
		calendar.authorization.sub = "monty@unirestaurantclub.com"
		calendar.authorization.fetch_access_token!
    calendar
  end

  def self.create_datetime(time, info)
    Calendar::EventDateTime.new(
        date_time: time.utc.to_datetime.rfc3339,
        time_zone: info[:timezone]
      )
  end

  def self.create_reminders(event_data)
      Calendar::Event::Reminders.new(
        use_default: false,
        overrides: self.create_notifications(event_data[:methods_and_minutes])
      )
  end

  def self.create_event(event_data)
    calendar = self.create_calendar_and_authorize
    cal = Rails.env == "production" ? ENV["GOOGLE_MAIN_CALENDAR"] : "primary"
    event = Calendar::Event.new(
      summary: event_data[:summary],
      location: event_data[:address],
      description: event_data[:description],
      start: self.create_datetime(event_data[:start_time], event_data),
      end: self.create_datetime(event_data[:end_time], event_data),
      attendees: self.create_attendees(event_data[:emails]),
      reminders: self.create_reminders(event_data)
    )
    begin
      result = calendar.insert_event(cal, event, send_notifications: true)
    rescue Exception => e
      Airbrake.notify("Could not create google event", {
        error: e,
        event_data: event_data
      })
      result = nil
    end

    return result
  end
end
