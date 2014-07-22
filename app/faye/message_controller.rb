class MessageController < FayeRails::Controller

	channel '/threads/messages/*' do
    monitor :subscribe do
      Emlogger.instance.log "Client #{client_id} subscribed to #{channel}."
      puts "Client #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      Emlogger.instance.log "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      Emlogger.instance.log "Client #{client_id} published #{data.inspect} to #{channel}."
      
      guid = data["guid"]
      published_message = Hashie::Mash.new(data["message"])
      Emlogger.instance.log "Message: #{published_message}"
      

      thread = MessageController.message_thread(channel)
      Emlogger.instance.log "Thread: #{thread.inspect}"
      message = thread.messages.create(
        author_id: published_message.author_id,
        body: published_message.body,
        timestamp: published_message.timestamp
      )
      Emlogger.instance.log "Message: #{message.inspect}"
      MessageController.push_message_to_recipients message, guid
    end
  end

  def self.push_message_to_recipients message, guid
    Emlogger.instance.log "pushing"
    thread = message.message_thread

    thread.user_ids.each do |user_id|
      Emlogger.instance.log "pushing to #{user_id}"
      response = {message_thread: thread.to_json, guid: guid}
      MessageController.publish("/users/messages", response)
    end 
  end

  def self.message_thread(channel)
    Emlogger.instance.log "Looking for message thread"
    thread_id = /.*\/(.*)/.match(channel)[1]
    Emlogger.instance.log "Thread ID: #{thread_id}"
    return MessageThread.find(thread_id)
  end

end

