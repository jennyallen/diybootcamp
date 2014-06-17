require 'icalendar'

class Scheduler

	def initialize
		@cal = Icalendar::Calendar.new
	end

	attr_accessor :cal


	def scheduleEvent(event)

		 @cal.event do |e|
			e.dtstart = event.event_start 
			e.dtend   = event.event_end 
			e.summary = event.summary
			e.description = event.description
		end
	end

	def export (filename)
		calstring = @cal.to_ical
		File.open(filename, 'w') { |file| file.write(calstring) }
	end
	
end

class Event
	def initialize (name)
		@name = name
		@event_start = DateTime.new(2014, 6, 13, 13, 0, 0)
		@event_end = DateTime.new(2014, 6, 14, 1, 0, 0)
		@summary = "A Class"
		@description = "Go to class-- Mama is watching!"
	end

	def myalarm(message, email)
		self.alarm do |a|
		    a.action          = "EMAIL"
		    a.description     = message # email body (required)
		    a.summary         = "Alarm notification"        # email subject (required)
		    a.attendee        = ["mailto:" + email]
		    a.trigger         = "-PT15M" # 15 minutes before
		end
	end


	attr_accessor :name
	attr_accessor :event_start
	attr_accessor :event_end
	attr_accessor :summary
	attr_accessor :description

end



