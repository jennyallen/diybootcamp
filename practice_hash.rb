require 'date'
require 'time'

def returnhash
	practicehash = {:professor=>"Shiller, Robert J.", :number=>"ECON 252", :link=>"/economics/econ-252-08", :department=>"Economics", :department_link=>"/economics", :title=>"Financial Markets (2008)", :sessions=>[{:title=>"Finance and Insurance as Powerful Forces in Our Economy and Society", :link=>"/economics/econ-252-08/lecture-1"}, {:title=>"The Universal Principle of Risk Management: Pooling and the Hedging of Risks", :link=>"/economics/econ-252-08/lecture-2"}, {:title=>"Technology and Invention in Finance", :link=>"/economics/econ-252-08/lecture-3"}, {:title=>"Portfolio Diversification and Supporting Financial Institutions (CAPM Model)", :link=>"/economics/econ-252-08/lecture-4"}, {:title=>"Insurance: The Archetypal Risk Management Institution", :link=>"/economics/econ-252-08/lecture-5"}, {:title=>"Efficient Markets vs. Excess Volatility", :link=>"/economics/econ-252-08/lecture-6"}, {:title=>"Behavioral Finance: The Role of Psychology", :link=>"/economics/econ-252-08/lecture-7"}, {:title=>"Human Foibles, Fraud, Manipulation, and Regulation", :link=>"/economics/econ-252-08/lecture-8"}, {:title=>"Guest Lecture by David Swensen", :link=>"/economics/econ-252-08/lecture-9"}, {:title=>"Debt Markets: Term Structure", :link=>"/economics/econ-252-08/lecture-10"}, {:title=>"Midterm Exam 1", :link=>"/economics/econ-252-08/exam-1"}, {:title=>"Stocks", :link=>"/economics/econ-252-08/lecture-11"}, {:title=>"Real Estate Finance and Its Vulnerability to Crisis", :link=>"/economics/econ-252-08/lecture-12"}, {:title=>"Banking: Successes and Failures", :link=>"/economics/econ-252-08/lecture-13"}, {:title=>"Guest Lecture by Andrew Redleaf", :link=>"/economics/econ-252-08/lecture-14"}, {:title=>"Guest Lecture by Carl Icahn", :link=>"/economics/econ-252-08/lecture-15"}, {:title=>"The Evolution and Perfection of Monetary Policy", :link=>"/economics/econ-252-08/lecture-16"}, {:title=>"Midterm Exam 2", :link=>"/economics/econ-252-08/exam-2"}, {:title=>"Investment Banking and Secondary Markets", :link=>"/economics/econ-252-08/lecture-17"}, {:title=>"Professional Money Managers and Their Influence", :link=>"/economics/econ-252-08/lecture-18"}, {:title=>"Brokerage, ECNs, etc.", :link=>"/economics/econ-252-08/lecture-19"}, {:title=>"Guest Lecture by Stephen Schwarzman", :link=>"/economics/econ-252-08/lecture-20"}, {:title=>"Forwards and Futures", :link=>"/economics/econ-252-08/lecture-21"}, {:title=>"Stock Index, Oil and Other Futures Markets", :link=>"/economics/econ-252-08/lecture-22"}, {:title=>"Options Markets", :link=>"/economics/econ-252-08/lecture-23"}, {:title=>"Making It Work for Real People: The Democratization of Finance", :link=>"/economics/econ-252-08/lecture-24"}, {:title=>"Okun Lecture: Learning from and Responding to Financial Crisis, Part I (Guest Lecture by Lawrence Summers)", :link=>"/economics/econ-252-08/lecture-25"}, {:title=>"Okun Lecture: Learning from and Responding to Financial Crisis, Part II (Guest Lecture by Lawrence Summers)", :link=>"/economics/econ-252-08/lecture-26"}, {:title=>"Final Exam", :link=>"/economics/econ-252-08/exam-3"}], :time=>58}

	practicehash[:sessions].length



end

def createOneWeek

	date = DateTime.now

	dow = date.wday

	availability_hash = {"Sunday"=>{:availableHours=>[false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false], :totalHours=>2}, "Monday"=>{:availableHours=>[false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false], :totalHours=>2}, "Tuesday"=>{:availableHours=>[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, false, false, false, false], :totalHours=>3}, "Wednesday"=>{:availableHours=>[false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false], :totalHours=>1}, "Thursday"=>{:availableHours=>[false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false], :totalHours=>2}, "Friday"=>{:availableHours=>[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false], :totalHours=>0}, "Saturday"=>{:availableHours=>[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false], :totalHours=>0}}

	puts availability_hash

	availability_array = []

	availability_hash.each do |key, value|
		case key
			when "Sunday"
				availability_array[0] = value[:availableHours]
			when "Monday"
				availability_array[1] = value[:availableHours]
			when "Tuesday"
				availability_array[2] = value[:availableHours]
			when "Wednesday"
				availability_array[3] = value[:availableHours]
			when "Thursday"
				availability_array[4] = value[:availableHours]
			when "Friday"
				availability_array[5] = value[:availableHours]
			when "Saturday"
				availability_array[6] = value[:availableHours]
		end
	end

	oneWeekSchedule = []

	hoursPerWeek = 7

	for index in 0..6 
		dayindex = (index + dow) % 7 #reindex to start at the start date specified by user
		day = availability_array[dayindex]
		day.each_with_index do |hour, hourindex|
			if hoursPerWeek <= 0
				break
			end

			if hour == true
				hoursPerWeek-=1 
				dayoffset = (dayindex - dow) % 7
				oneWeekSchedule.push([hourindex, dayoffset])
			end
		end
	end

	oneWeekSchedule

end

def createTotalSchedule(hours, hoursPerWeek, oneWeekSchedule)
	totalAvailabilityArray = []
	weeks=(hours+hoursPerWeek-1)/hoursPerWeek #ceiling, round up weeks
	(0...weeks).each do |week|
		oneWeekSchedule.each do |session|
			#schedule the right amount of hours
			if hours <= 0
				break
			end

			puts hours

			totalAvailabilityArray.push([session[0], session[1]+7*week])

			hours -= 1
		end
	end
	totalAvailabilityArray
end



