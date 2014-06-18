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

def convert_to_time (number)
	if number >= 12
		number_s = 
			if number == 12
				number.to_s
			else
				(number % 12).to_s
			end
		number_s += "pm"		 
	else
		number_s = 
			if number == 0
				number = 12
				number.to_s
			else
				number.to_s
			end
		number_s += "am"
	end

	return number_s
end




get '/scheduler' do
	timearr = Array.new
	(0...23).each do |hour|
		starttime = hour 
		endtime = hour + 1
		timestr = convert_to_time(starttime) + " to " + convert_to_time(endtime)
		timearr[hour] = timestr
	end

	dayarr = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]


 	erb :scheduler, locals: {timearr: timearr, dayarr: dayarr}

end