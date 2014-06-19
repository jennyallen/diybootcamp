require 'nokogiri'
require 'open-uri'

class Scraper
	def self.courses_to_hasharray
	# Get a Nokogiri::HTML:Document for the page we’re interested in...

		@@courses = File.read("./all_courses")

		doc = Nokogiri::HTML(open('http://oyc.yale.edu/courses'))
		courses = []

		#need to discard first row (th)
		doc.css('tr').drop(1).each do |row|
		  	courses.push({:professor => row.css('td.views-field-field-course-professors-name-value').text.strip!,
		  				:number => row.css('td.views-field-field-course-number-value').css('a').text,
		  				:link => row.css('td.views-field-field-course-number-value').css('a')[0]['href'],
		  				:department => row.css('td.views-field-field-course-department-nid').css('a')[1].text,
		  				:department_link => row.css('td.views-field-field-course-department-nid').css('a')[1]['href'],
		  				:title => row.css('td.views-field-title').text.strip!})
		end

		return courses 

	end

	def self.get_sessions(hasharray)

		hasharray.each_with_index do |course_hash, i|
			url = 'http://oyc.yale.edu' + course_hash[:link] + '#sessions'
			doc = Nokogiri::HTML(open(url))

			sessions = []

			doc.css('tbody').css('tr').each do |row|
				sessions.push({:title => row.css('td.views-field-field-session-display-title-value').css('a')[0].text,
							   :link => row.css('td.views-field-field-session-display-title-value').css('a')[0]['href']})
			end

			course_hash[:sessions]=sessions
			course_hash[:time]=sessions.length*2 #Time in hours for (1hr video + 1hr study)/lecture
			hasharray[i] = course_hash
		end

		return hasharray
	end

	def self.coursearray
		return get_sessions(courses_to_hasharray)
	end

	#have a :changed bool value in the session that says whether the schedule needs to be updated. 
	#Change when you post from either shed or avail
	#Then, re run algo/schedule function...
	#later, make droppable by starting part way in...

	#make a :my_courses array of indexes on post

	def self.update
		File.open('all_courses', 'w') {|file| file.write(self.update)}
		@@courses = File.read("./all_courses")
	end
end