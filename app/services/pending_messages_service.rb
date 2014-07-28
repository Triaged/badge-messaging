class PendingMessagesService

	def initialize user
		@user = user
	end

	def publish_pending_threads
		pending_threads = @user.pending_message_threads
		pending_threads.each do |thread|
			publish_thread @user.last_seen_at
		end
	end

	def publish_thread messages_since
		data = {message_thread: @thread.with_messages_since(messages_since)}
		ThreadChannelController.publish("/users/messages/#{user.id}", data)
	end

end