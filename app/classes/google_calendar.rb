require 'google/apis/calendar_v3'
require 'base_cli'

class GoogleCalendar

  def self.create_attendees(emails)
    attendees = []
    emails.each do |email|
      attendees << Google::Apis::CalendarV3::EventAttendee.new(email: email)
    end
    attendees
  end

  # methods and minutes example:
  # [["email", (24 * 60)], ["popup", 10]]
  def self.create_notifications(methods_and_minutes)
    notifications = []
    methods_and_minutes.each do |data|
      notifications << Google::Apis::CalendarV3::EventReminder.new(
        reminder_method: data[0],
        minutes: data[1]
      )
    end
    notifications
  end

  def self.create_event(event_data)
    event = Google::Apis::CalendarV3::Event.new(
      summary: event_data[:summary],
      location: event_data[:address],
      description: event_data[:description],
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event_data[:start_time],
        time_zone: event_data[:timezone]
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event_data[:end_time],
        time_zone: event_data[:timezone]
      ),
      attendees: self.create_attendees(event_data[:emails]),
      reminders: Google::Apis::CalendarV3::Event::Reminders.new(
        use_default: false,
        overrides: self.create_notifications(event_data[:methods_and_minutes])
      )
    )

    result = client.insert_event('primary', event)
    return result
  end
=begin
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
