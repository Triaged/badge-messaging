class NewMessageService

	def initialize thread, data
		@thread = thread
		@published_message = data.message
		@guid = data.guid
	end

	def persist_and_deliver_message!
		message = persist_message
		Emlogger.instance.log "Saved #{message.inspect}"
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
		if present?(user_id)
			deliver_faye_message_to_recipient user_id, message
		end
		deliver_external_message_to_recipient user_id, message
	end

	def present? user_id
		time_now = Time.now.to_f
		last_seen = User.find(user_id).last_seen_at
		time_diff = time_now - last_seen
		Emlogger.instance.log time_now
		Emlogger.instance.log "-------"
		Emlogger.instance.log last_seen
		Emlogger.instance.log "-------"
		Emlogger.instance.log (time_now - last_seen)
		(time_diff > 0) && (time_diff < 1.0)
	end

	def deliver_faye_message_to_recipient user_id, message
		Emlogger.instance.log "Sending Faye Message: #{faye_message_format(message)} to user: #{user_id}"
		ThreadChannelController.publish("/users/messages/#{user_id}", faye_message_format(message))
	end

	def deliver_external_message_to_recipient user_id, message
		unless user_id == message.author_id
			Emlogger.instance.log "Sending External Message to user: #{user_id}"
			BadgeClient.new.deliver_message user_id, @thread, message
		else
			Emlogger.instance.log "Current User #{user_id} is Offline"
		end
	end

	def faye_message_format message
		Emlogger.instance.log "faye message format"
		Emlogger.instance.log @thread.with_message(message)
		{message_thread: @thread.with_message(message), guid: @guid}
	end



end