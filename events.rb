require 'date'
require 'time'
require 'icalendar'

def period_to_event(start,period,email)

	event = Icalendar::Event.new
	event.dtstart = start + period.dayOffset + Rational(period.hourOffset, 24)
	event.dtend = event.dtstart + Rational(1, 24)

	#puts period.class

	event.alarm do |a|
	    a.action          = "EMAIL"
#   	    a.description     = <<-END_OF_MESSAGE
		

# <h1>Mama Says:</h1>
# Time to get to work!
# Class is in session and YOU ARE ALREADY LATE! <a href=#{period.link}>Join in!</a>
#  	    END_OF_MESSAGE
 	    a.summary         = "A"        # email subject (required)
	    a.attendee        = %w(mailto:#{email})# mailto:#{email}) # one or more email recipients (required)
	    #a.append_attendee "mailto:me-three@my-domain.com"
	    a.trigger         = "-PT0M" # 15 minutes before
	    #a.append_attach   Icalendar::Values::Uri.new "ftp://host.com/novo-procs/felizano.exe", "fmttype" => "application/binary" # email attachments (optional)
	end

	if period.class.to_s == "ClassPeriod"
		event.summary = period.coursetitle.to_s
		 # puts ""
		 # puts period.coursetitle
		 # puts period.coursetitle.to_s
		 # puts period.lecturenumber
		 # puts period.lecturetitle
		 # puts period.link
		#event.description = "Session " + (period.lecturenumber + 1).to_s + ": " + period.lecturetitle + "\n" + "http://oyc.yale.edu" + period.link
		event.description = "http://oyc.yale.edu" + period.link
		puts event.description
		puts "#{email}"
	else 
		puts ""
		event.summary = "Study hall for: " + period.coursetitle.to_s
		#event.description = "Do your homework! " + period.link
		event.description = "Do your homework!"
	end

	return event
end

def get_events(start,periods,email)
	periods.each_with_index do |period, i|
		periods[i] = period_to_event(start, period, email)
	end

	return periods
end

def add_to_cal(cal,start,periods,email)
	classes = get_events(start,periods,email)

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