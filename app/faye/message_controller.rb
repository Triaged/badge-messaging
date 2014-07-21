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
      
      thread = message_thread(channel)
      message = thread.messages.create(
        author_id: published_message.author_id,
        body: published_message.body,
        timestamp: published_message.timestamp
      )
      
      push_message_to_recipients message, guid
    end
  end

  def push_message_to_recipients message, guid
    thread = message.thread
    thread.users.each do |user|
      response = {message_thread: thread.to_json, guid: guid}
      MessageController.publish("/users/messages/#{user.id}", response)
    end 
  end

  def message_thread(channel)
    thread_id = /.*\/(.*)/.match(channel)[1]
    return MessageThread.find(thread_id)
  end

end

