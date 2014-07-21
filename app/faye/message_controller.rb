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
      
      thread = MessageThread.first
      message = thread.messages.create(
        author_id: published_message.author_id,
        body: published_message.body,
        timestamp: published_message.timestamp
      )

      response = {message_thread: thread.to_json, guid: guid}
      Emlogger.instance.log response
      MessageController.publish("/users", response)
    end
  end
end