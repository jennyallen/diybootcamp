require 'nokogiri'
require 'open-uri'

def courses_to_hasharray
# Get a Nokogiri::HTML:Document for the page we’re interested in...

doc = Nokogiri::HTML(open('http://oyc.yale.edu/courses'))
courses = []
profs = []

 # doc.css('tr').each do |row|
 # 	courses.push({:professor => row.css('td.views-field-field-course-professors-name-value').text,
 # 				:number => row.css('td.views-field-field-course-number-value').css('a').text,
 # 				:link => row.css('td.views-field-field-course-number-value'),#.css('a')[0]['href'],
 # 				:department => row.css('td.views-field-field-course-department-nid'),#.css('a')[1].text,
 # 				:department_link => row.css('td.views-field-field-course-department-nid'),#.css('a')[1]['href'],
 # 				:title => row.css('td.views-field-title').text})
 # end

 courses = doc.css('tr').css('td.views-field-field-course-number-value').css('a')#[0]['href']

return courses #doc.css('tr')[1].css('td')[0]
#return doc.css('xmlns|tr')
# return table('views-field-field-course-professors-name-value')



end

puts courses_to_hasharray


# views-field-field-course-department-nid
# views-field-field-course-number-value
# views-field-title
# views-field-field-course-professors-name-value
