require 'net/smtp'

class Emailer
	@@address = ""

	def self.update(email)
		@@address = email
	end

	def self.mail(link)

#for some reason this special format cannot have leading whitespace or it breaks!
	    msg = <<-END_OF_MESSAGE
From: MAMA <follo.tim@gmail.com>
To: BAD_STUDENT <#{@@address}>
subject: Mama is cross with you
Content-type: text/html
		

<h1>Mama Says:</h1>
Time to get to work!
Class is in session and YOU ARE ALREADY LATE! <a href=#{link}>Join in!</a>
	    END_OF_MESSAGE
	    smtp = Net::SMTP.new 'smtp.gmail.com', 587
	    smtp.enable_starttls
	    smtp.start('gmail.com', 'follo.tim@gmail.com', '-Antigone', :login) do
	      smtp.send_message(msg, 'follo.tim@gmail.com', @@address)
	    end
	end
end