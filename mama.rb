require 'icalendar'
require 'sinatra'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'
require 'pry'
require './all_courses.rb'
require './emailer.rb'
require './events.rb'
require './practice_hash'
require './scraper.rb'
require 'date'
require 'time'

enable :sessions
enable :method_override

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
		session['pickedcourses'] = false
		session['pickedschedule'] = false
	erb :index
end

get '/courses' do
	courses = stored_courses

	erb :courseselection, locals: {courses: courses}
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

	session['pickedschedule'] = true

	daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

	hoursInWeek = Array.new(168)

	hoursInWeek.each {|hour| hour = false}

	if params['startdate'] == ''
		startdate = DateTime.now
	else
		startdate = dateConverter(params['startdate'])
	end

	daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

	# daysOfWeek.each do |day, hash|
	# 	starttime = timeToNum(params[day+"-starttime"])
	# 	endtime = timeToNum(params[day+"-endtime"])
	# 	puts "Starttime" + params[day+"-starttime"] + " Parsed Input: " + starttime.to_s
	# 	puts "EndTime" + params[day+"-endtime"] + " Parsed Input: " + endtime.to_s
	# 	hash[:availableHours] = createDayArray(starttime, endtime)
	# 	hash[:totalHours] = endtime - starttime
	# end

<<<<<<< HEAD

	daysOfWeek.each do |day, hash|
=======
	#Figures out the slots of time that are available each week
	weekavail = WeekAvailability.new

	daysOfWeek.each do |day|
>>>>>>> 4625b14fd0275488fb6a81dc756ece5d7010f9e4
		starttime = timeToNum(params[day+"-starttime"])
	 	endtime = timeToNum(params[day+"-endtime"])
	 	#Find slots of time that are available each day
	 	case day 
		  	when "Monday"
		 		weekavail.Monday = DayAvailability.new(day, createDayArray(starttime, endtime), endtime-starttime)
			when "Tuesday"
				weekavail.Tuesday = DayAvailability.new(day, createDayArray(starttime, endtime), endtime-starttime)
			when "Wednesday"
				weekavail.Wednesday= DayAvailability.new(day, createDayArray(starttime, endtime), endtime-starttime)
			when "Thursday"
				weekavail.Thursday = DayAvailability.new(day, createDayArray(starttime, endtime), endtime-starttime)
			when "Friday"
				weekavail.Friday = DayAvailability.new(day, createDayArray(starttime, endtime), endtime-starttime)
			when "Saturday"
				weekavail.Saturday = DayAvailability.new(day, createDayArray(starttime, endtime), endtime-starttime)
			when "Sunday"
				weekavail.Sunday = DayAvailability.new(day, createDayArray(starttime, endtime), endtime-starttime)
		end

	end


	#hours Per Week that you are willing to work
	hoursperweek = params['hoursPerWeek'].to_i

	weeksched = WeekSchedule.new(startdate, weekavail.weekArray, hoursperweek.to_i)


	#create a schedule of weekly availability
	weeklysched = weeksched.createSchedule
	puts weeklysched

	#create total schedule 
	totalsched = TotalSchedule.new(58, hoursperweek.to_i)

	h = {:professor=>"Shiller, Robert J.", :number=>"ECON 252", :link=>"/economics/econ-252-08", :department=>"Economics", :department_link=>"/economics", :title=>"Financial Markets (2008)", :sessions=>[{:title=>"Finance and Insurance as Powerful Forces in Our Economy and Society", :link=>"/economics/econ-252-08/lecture-1"}, {:title=>"The Universal Principle of Risk Management: Pooling and the Hedging of Risks", :link=>"/economics/econ-252-08/lecture-2"}, {:title=>"Technology and Invention in Finance", :link=>"/economics/econ-252-08/lecture-3"}, {:title=>"Portfolio Diversification and Supporting Financial Institutions (CAPM Model)", :link=>"/economics/econ-252-08/lecture-4"}, {:title=>"Insurance: The Archetypal Risk Management Institution", :link=>"/economics/econ-252-08/lecture-5"}, {:title=>"Efficient Markets vs. Excess Volatility", :link=>"/economics/econ-252-08/lecture-6"}, {:title=>"Behavioral Finance: The Role of Psychology", :link=>"/economics/econ-252-08/lecture-7"}, {:title=>"Human Foibles, Fraud, Manipulation, and Regulation", :link=>"/economics/econ-252-08/lecture-8"}, {:title=>"Guest Lecture by David Swensen", :link=>"/economics/econ-252-08/lecture-9"}, {:title=>"Debt Markets: Term Structure", :link=>"/economics/econ-252-08/lecture-10"}, {:title=>"Midterm Exam 1", :link=>"/economics/econ-252-08/exam-1"}, {:title=>"Stocks", :link=>"/economics/econ-252-08/lecture-11"}, {:title=>"Real Estate Finance and Its Vulnerability to Crisis", :link=>"/economics/econ-252-08/lecture-12"}, {:title=>"Banking: Successes and Failures", :link=>"/economics/econ-252-08/lecture-13"}, {:title=>"Guest Lecture by Andrew Redleaf", :link=>"/economics/econ-252-08/lecture-14"}, {:title=>"Guest Lecture by Carl Icahn", :link=>"/economics/econ-252-08/lecture-15"}, {:title=>"The Evolution and Perfection of Monetary Policy", :link=>"/economics/econ-252-08/lecture-16"}, {:title=>"Midterm Exam 2", :link=>"/economics/econ-252-08/exam-2"}, {:title=>"Investment Banking and Secondary Markets", :link=>"/economics/econ-252-08/lecture-17"}, {:title=>"Professional Money Managers and Their Influence", :link=>"/economics/econ-252-08/lecture-18"}, {:title=>"Brokerage, ECNs, etc.", :link=>"/economics/econ-252-08/lecture-19"}, {:title=>"Guest Lecture by Stephen Schwarzman", :link=>"/economics/econ-252-08/lecture-20"}, {:title=>"Forwards and Futures", :link=>"/economics/econ-252-08/lecture-21"}, {:title=>"Stock Index, Oil and Other Futures Markets", :link=>"/economics/econ-252-08/lecture-22"}, {:title=>"Options Markets", :link=>"/economics/econ-252-08/lecture-23"}, {:title=>"Making It Work for Real People: The Democratization of Finance", :link=>"/economics/econ-252-08/lecture-24"}, {:title=>"Okun Lecture: Learning from and Responding to Financial Crisis, Part I (Guest Lecture by Lawrence Summers)", :link=>"/economics/econ-252-08/lecture-25"}, {:title=>"Okun Lecture: Learning from and Responding to Financial Crisis, Part II (Guest Lecture by Lawrence Summers)", :link=>"/economics/econ-252-08/lecture-26"}, {:title=>"Final Exam", :link=>"/economics/econ-252-08/exam-3"}], :time=>58}

	# totalsched.createAvailabilityArray(h)
	# totalsched.createCourseArray(h)
	totalsched.createAvailabilityArray(weeklysched)
	totalsched.createCourseArray(h)
	coursearr = totalsched.createScheduleArray(h)

	cal = Icalendar::Calendar.new
	cal = add_to_cal(cal,startdate,coursearr)
	cal_string = cal.to_ical

	File.open('public/newcal.ics', 'w') { |file| file.write(cal_string) }

	puts totalsched.to_s
	puts coursearr.to_s

	# starttime = timeToNum(starttime)
	# endtime = timeToNum(endtime)
	erb :availabilitysuccess

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
	courses = []

	if params[:item] == nil
		session['pickedcourses'] = false
		erb :no_courseselection
	else
		session['selectedcourses'].each do |course|
			courses.push(stored_courses[course.to_i])
		end
		session['pickedcourses'] = true
		erb :coursesuccess, locals: {courses: courses, session: session}
	end
end




