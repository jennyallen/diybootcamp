require 'Date'
require 'Time'
require 'icalendar'

def period_to_event(start,period)
	event = Icalendar::Event.new
	event.dtstart = start + period.dayOffset + Rational(period.hourOffset, 24)
	event.dtend = event.dtstart + Rational(1, 24)
	event.summary = period.coursetitle

	event.alarm do |a|
	    a.action          = "EMAIL"
	    a.description     = <<-END_OF_MESSAGE
From: MAMA <follo.tim@gmail.com>
To: BAD_STUDENT <timothy.follo@yale.edu>
subject: Mama is cross with you
Content-type: text/html
		

<h1>Mama Says:</h1>
Time to get to work!
Class is in session and YOU ARE ALREADY LATE! <a href=#{period.link}>Join in!</a>
	    END_OF_MESSAGE
	    a.summary         = "Alarm notification"        # email subject (required)
	    a.attendee        = %w(mailto:timothy.follo@yale.edu) # one or more email recipients (required)
	    #a.append_attendee "mailto:me-three@my-domain.com"
	    a.trigger         = "-PT0M" # 15 minutes before
	    #a.append_attach   Icalendar::Values::Uri.new "ftp://host.com/novo-procs/felizano.exe", "fmttype" => "application/binary" # email attachments (optional)
	end

	if period.class == "ClassPeriod"
		event.description = period.lecturenumber + ": " + period.lecturetitle + "\n" + period.link
	else 
		event.description = "Do your homework!"
	end

	return event
end

def get_events(start,periods)
	periods.each_with_index do |period, i|
		periods[i] = period_to_event(start, period)
	end

	return periods
end

def add_to_cal(cal,start,periods)
	classes = get_events(start,periods)

	periods.each do |class_session|
		cal.add_event(class_session)
	end

	return cal
end

# cal.event do |e|
#   # ...other event properties
#   e.alarm do |a|
#     a.action          = "EMAIL"
#     a.description     = "This is an event reminder" # email body (required)
#     a.summary         = "Alarm notification"        # email subject (required)
#     a.attendee        = %w(mailto:me@my-domain.com mailto:me-too@my-domain.com) # one or more email recipients (required)
#     a.append_attendee "mailto:me-three@my-domain.com"
#     a.trigger         = "-PT15M" # 15 minutes before
#     a.append_attach   Icalendar::Values::Uri.new "ftp://host.com/novo-procs/felizano.exe", "fmttype" => "application/binary" # email attachments (optional)

#   e.alarm do |a|
#     a.action  = "DISPLAY" # This line isn't necessary, it's the default
#     a.summary = "Alarm notification"
#     a.trigger = "-P1DT0H0M0S" # 1 day before
#   end

#   e.alarm do |a|
#     a.action        = "AUDIO"
#     a.trigger       = "-PT15M"
#     a.append_attach "Basso"
#   end
# end


# event = Icalendar::Event.new
# # event.dtstart = DateTime.civil(2006, 6, 23, 8, 30)
# event.summary = "A great event!"
# cal.add_event(event)

# event2 = cal.event  # This automatically adds the event to the calendar
# event2.dtstart = DateTime.civil(2006, 6, 24, 8, 30)
# event2.summary = "Another great event!"

# cal = Icalendar::Calendar.new

# event = cal.event do |e|
# 	e.dtstart = DateTime.civil(2014, 6, 13, 8, 30)
#   	e.dtend   = DateTime.civil(2014, 6, 13, 9, 30)
# 	e.summary = "This is a summary with params."
# end

# email = "jenjess.jallen@gmail.com"

# event.alarm do |a|
#     a.action          = "EMAIL"
#     a.description     = "This is an event reminder" # email body (required)
#     a.summary         = "Mama Homeschool Reminding you!"        # email subject (required)
#     a.attendee        = ["mailto:" + email] # one or more email recipients (required)
#     a.trigger         = "-PT20M" # 15 minutes before
#     # a.append_attach   Icalendar::Values::Uri.new "ftp://host.com/novo-procs/felizano.exe", "fmttype" => "application/binary" # email attachments (optional)
# end

# cal_string = cal.to_ical