class ReadMessageController

	def initialize thread, data
		@thread = thread
		@message_ids = data.message
		@guid = data.guid
	end

	def read!
		@thread.messages
		deliver_message_to_recipients message
		return message
	end

	


end