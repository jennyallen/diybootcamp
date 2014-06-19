require 'icalendar'
require 'sinatra'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative 'practice_hash'
require_relative 'scraper'

enable :sessions
enable :method_override

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

get '/' do
	erb :index
end

get '/courses' do
	erb :courseselection
end

get '/scheduler' do

	dayarr = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
 	erb :scheduler, locals: {dayarr: dayarr}

end

get '/scheduler/yournewschedule' do
	erb :userschedule
end

get '/about' do 
	erb :about
end



def dateConverter(datestr) 
	monthsH = {"January"=>1, "February"=>2, "March"=>3, "April"=>4, "May"=>5, "June"=>6, "July"=>7,
				"August"=>8, "September"=>9, "October"=>10, "November"=>11, "December"=>12}
				
	startdatearr = datestr.delete(',').split(" ")
	year = startdatearr[2].to_i

	puts startdatearr
	puts monthsH
	month = monthsH[startdatearr[1]]
	puts month
	day = startdatearr[0].to_i
	DateTime.new(year, month, day, 0, 0, 0, -4)
end

def timeToNum(timestr)
	if timestr == nil || timestr == ''
		timenum = 0
	else
		timearr = timestr.split(':')
		timenum = timearr[0].to_i

		if timestr.include?('PM')
			if timenum != 12
				timenum += 12
			end
		end

		if timenum == 12 && timestr.include?('AM')
			timenum = 0
		end

	end

	timenum
end

def createDayArray(starttime, endtime)
	hoursInDay = Array.new(24) {false}
	for i in starttime...endtime
		hoursInDay[i] = true
	end

	return hoursInDay
end



def oneWeekSchedule

end



post '/scheduler/yournewschedule' do 

	daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

	hoursInWeek = Array.new(168)

	hoursInWeek.each {|hour| hour = false}

	if params['startdate'] == ''
		startdate = DateTime.now
	else
		startdate = dateConverter(params['startdate'])
	end

	daysOfWeek = {"Sunday"=>{}, "Monday"=>{}, "Tuesday"=>{}, "Wednesday"=>{}, "Thursday"=>{}, "Friday"=>{}, "Saturday"=>{}}

	daysOfWeek.each do |day, hash|
		starttime = timeToNum(params[day+"-starttime"])
		endtime = timeToNum(params[day+"-endtime"])
		puts "Starttime" + params[day+"-starttime"] + " Parsed Input: " + starttime.to_s
		puts "EndTime" + params[day+"-endtime"] + " Parsed Input: " + endtime.to_s
		hash[:availableHours] = createDayArray(starttime, endtime)
		hash[:totalHours] = endtime - starttime
	end



	File.open('availability_hash', 'w') {|file| file.write(daysOfWeek.to_s)}




	# starttime = timeToNum(starttime)
	# endtime = timeToNum(endtime)

	erb :userschedule

end

# get '/courses' do
# 	if session[:availiable_hours] == nil
# 		erb :no_courseselection
# 	else
# 		erb :courseselection, locals: {session: session}
# 	end
# end

post '/courses' do
	session['selectedcourses'] ||= {}
	session['selectedcourses'] = params[:item]
	allthecoursepicked = []

	session['selectedcourses'].each do |course|
		allthecoursepicked.push()
	end

end




