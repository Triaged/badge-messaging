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
		timestamp = Time.now.to_f

		message = @thread.messages.create(
      author_id: @published_message.author_id,
      body: @published_message.body,
      timestamp: timestamp
    )
    
    # Hack to update @thread's updated_at
    @thread.update_attribute(:timestamp, timestamp)
    
    return message
	end

	def deliver_message_to_recipients message
		@thread.user_ids.each { |user_id| deliver_message_to_recipient user_id, message } 
  end

	def deliver_message_to_recipient user_id, message
		user = User.where(id: user_id).first
		deliver_faye_message_to_recipient user, message
		deliver_external_message_to_recipient user_id, message

		# if user && user.present?
		# 	Emlogger.instance.log "user #{user.id} is present"
		# 	deliver_faye_message_to_recipient user, message
		# else
		# 	deliver_external_message_to_recipient user_id, message
		# end
	end

	def present? user_id
		User.where(id: user_id, :last_seen_at.gte => (Time.now.to_f - 0.250)).count > 0
	end

	def deliver_faye_message_to_recipient user, message
		Emlogger.instance.log "Sending Faye Message: #{faye_message_format(message)} to user: #{user.id}"
		ThreadChannelController.publish("/users/messages/#{user.id}", faye_message_format(message))
	end

	def deliver_external_message_to_recipient user_id, message
		unless user_id == message.author_id
			Emlogger.instance.log "Sending External Message to user: #{user_id}"
			BadgeClient.new.deliver_message user_id, @thread, message
		end
	end

	def faye_message_format message
		{message_thread: @thread.with_message(message), guid: @guid}
	end



end