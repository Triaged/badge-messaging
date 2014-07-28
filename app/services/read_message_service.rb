class ReadMessageService

	def initialize thread, data
		@thread = thread
		@read_messages = data.message
		@guid = data.guid
	end

	def read!
		@read_messages.each do |msg|
			message = @thread.messages.find(msg.message_id)
			message.push(:read_by, msg.user_id)
		end
	end



# { "message_id" : "adfasf", "user_id" : "asdfafs" }
	


end