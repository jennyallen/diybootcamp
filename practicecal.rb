require 'icalendar'
require 'sinatra'
cal = Icalendar::Calendar.new

event = cal.event do |e|
	e.dtstart = DateTime.civil(2014, 6, 13, 8, 30)
  	e.dtend   = DateTime.civil(2014, 6, 13, 9, 30)
	e.summary = "This is a summary with params."
end

email = "jenjess.jallen@gmail.com"

event.alarm do |a|
    a.action          = "EMAIL"
    a.description     = "This is an event reminder" # email body (required)
    a.summary         = "Mama Homeschool Reminding you!"        # email subject (required)
    a.attendee        = ["mailto:" + email] # one or more email recipients (required)
    a.trigger         = "-PT20M" # 15 minutes before
    # a.append_attach   Icalendar::Values::Uri.new "ftp://host.com/novo-procs/felizano.exe", "fmttype" => "application/binary" # email attachments (optional)
end

cal_string = cal.to_ical



File.open('public/newcal.ics', 'w') { |file| file.write(cal_string) }