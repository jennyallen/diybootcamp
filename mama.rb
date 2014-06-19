require 'icalendar'
require 'sinatra'
require 'sinatra/reloader'


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

# File.open('public/newcal.ics', 'w') { |file| file.write(cal_string) }

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

get '/' do
	erb :index
end

get '/courses' do
	erb :courseselection
end

get '/scheduler' do

	dayarr = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]


 	erb :scheduler, locals: {dayarr: dayarr}

end

get '/scheduler/yournewschedule' do
	erb :userschedule
end

get '/about' do 
	erb :about
end

@monthsH = {"January"=>1, "February"=>2, "March"=>3, "April"=>4, "May"=>5, "June"=>6, "July"=>7,
				"August"=>8, "September"=>9, "October"=>10, "November"=>11, "December"=>12}

def dateConverter(datestr) 
	startdatearr = datestr.delete(',').split(" ")
	puts startdatearr
	DateTime.new(startdatearr[2].to_i, @monthsH[startdatearr[1]], startdatearr[0], 0, 0, 0, -4)
end


post '/scheduler/yournewschedule' do 

	daysOfWeek= ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	puts params['startdate']
	
	startdate = dateConverter(params['startdate']).to_s
	starttime = params['Monday-starttime'].to_s
	endtime = params['Monday-endtime'].to_s
	puts startdate
	puts starttime
	puts endtime
	erb :userschedule

end







