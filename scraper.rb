require 'nokogiri'
require 'open-uri'

def courses_to_hasharray
# Get a Nokogiri::HTML:Document for the page we’re interested in...

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

def get_sessions(hasharray)
	hasharray.each do |course|
		url = 'http://oyc.yale.edu/courses' + course[:link] + '#sessions'
		doc = Nokogiri::HTML(open(url))

		sessions = []

		doc.css('tbody').css('tr').each do |row|
			sessions.push({:title => row.css('td.views-field-field-session-display-title-value').css('a')[0].text,
						   :link => row.css('td.views-field-field-session-display-title-value').css('a')[0]['href']})
		end

		course[:sessions => sessions]

	end
end

def coursearray
	return get_sessions(courses_to_hasharray)
end