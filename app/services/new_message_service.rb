class NewMessageService

	def initialize thread, data
		@thread = thread
		@published_message = data.message
		@guid = data.guid
	end

	def persist_and_deliver_message!
		message = persist_message
		deliver_message_to_recipients message
		return message
	end

	def persist_message
		message = @thread.messages.create(
      author_id: @published_message.author_id,
      body: @published_message.body,
      timestamp: @published_message.timestamp
    )
    
    # Hack to update @thread's updated_at
    @thread.save
    return message
	end

	def deliver_message_to_recipients message
		@thread.users.each { |user| deliver_message_to_recipient user, message } 
  end

	def deliver_message_to_recipient user, message
		if user.present?
			deliver_faye_message_to_recipient user, message
		else
			deliver_external_message_to_recipient user, message
		end
	end

	def deliver_faye_message_to_recipient user, message
		Emlogger.instance.log "Sending Faye Message: #{faye_message_format(message)} to user: #{user.id}"
		ThreadChannelController.publish("/users/messages/#{user.id}", faye_message_format(message))
	end

	def deliver_external_message_to_recipient user, message
		unless user.id == message.author_id
			Emlogger.instance.log "Sending External Message to user: #{user.id}"
			BadgeClient.new.deliver_message user.id, message
		end
	end

	def faye_message_format message
		{message_thread: @thread.with_message(message), guid: @guid}
	end



end