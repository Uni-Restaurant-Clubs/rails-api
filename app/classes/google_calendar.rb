require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class GoogleCalendar

  Calendar = Google::Apis::CalendarV3
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

  def self.create_scheduled_time_confirmed_for_restaurant()
    restaurant = Restaurant.find_by(id: 3715)
    summary = "Uni Restaurant Club is sending a writer and photographer to your restaurant for a review!"
    description = TextContent.find_by(name: "notify restaurant that a review has been scheduled")&.text,
    start_time = restaurant.scheduled_review_date_and_time
    event_data = {
      summary: summary,
      description: description,
      address: restaurant.address&.full_address,
      writer: restaurant.writer,
      photographer: restaurant.photographer,
      start_time: start_time,
      end_time: (start_time + 2.hours),
      timezone: "America/New_York",
      methods_and_minutes: self.day_before_and_2_hours_before_reminders,
      emails: restaurant.primary_email&.strip,
    }
    return self.create_event(event_data)
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

  def self.create_event(event_data)
    calendar = Calendar::CalendarService.new
		scopes =  ['https://www.googleapis.com/auth/calendar',
               'https://www.googleapis.com/auth/gmail.send',
               'https://www.googleapis.com/auth/calendar.events',
               "https://www.googleapis.com/auth/admin.directory.resource.calendar"]
    calendar.authorization = Google::Auth::ServiceAccountCredentials.from_env(scope: scopes)
		calendar.authorization.sub = "monty@unirestaurantclub.com"
		calendar.authorization.fetch_access_token!

    event = Calendar::Event.new(
      summary: event_data[:summary],
      location: event_data[:address],
      description: event_data[:description],
      start: Calendar::EventDateTime.new(
        date_time: event_data[:start_time],
        time_zone: event_data[:timezone]
      ),
      end: Calendar::EventDateTime.new(
        date_time: event_data[:end_time],
        time_zone: event_data[:timezone]
      ),
      attendees: self.create_attendees(event_data[:emails]),
      reminders: Calendar::Event::Reminders.new(
        use_default: false,
        overrides: self.create_notifications(event_data[:methods_and_minutes])
      )
    )
    result = calendar.insert_event('primary', event, send_notifications: true)
    return result
  end
=begin
emails = ["montylennie@gmail.com", "monty@unirestaurantclub.com"]
# Create an event, adding any emails listed in the command line as attendees
event = Calendar::Event.new(summary: 'A sample event',
                            location: '1600 Amphitheatre Parkway, Mountain View, CA 94045',
                            attendees:  [Calendar::EventAttendee.new(email: "montylennie@gmail.com")],
                            start: Calendar::EventDateTime.new(date_time: DateTime.parse('2021-11-09T17:00:00')),
                            end: Calendar::EventDateTime.new(date_time: DateTime.parse('2021-11-09T18:00:00')))
    result = calendar.insert_event('primary', event, send_notifications: true)
    return result
  end
    event = Google::Apis::CalendarV3::Event.new(
      summary: 'Google I/O 2015',
      location: '800 Howard St., San Francisco, CA 94103',
      description: 'A chance to hear more about Google\'s developer products.',
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: '2015-05-28T09:00:00-07:00',
        time_zone: 'America/Los_Angeles'
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: '2015-05-28T17:00:00-07:00',
        time_zone: 'America/Los_Angeles'
      ),
      recurrence: [
        'RRULE:FREQ=DAILY;COUNT=2'
      ],
      attendees: [
        Google::Apis::CalendarV3::EventAttendee.new(
          email: 'lpage@example.com'
        ),
        Google::Apis::CalendarV3::EventAttendee.new(
          email: 'sbrin@example.com'
        )
      ],
      reminders: Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'email',
            minutes: 24 * 60
          ),
          Google::Apis::CalendarV3::EventReminder.new(
            reminder_method: 'popup',
            minutes: 10
          )
        ]
      )
    )

    result = client.insert_event('primary', event)
    puts "Event created: #{result.html_link}"
=end
end
