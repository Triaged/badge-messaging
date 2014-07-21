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
      
      Emlogger.instance.log data["guid"]

      guid = data["guid"]
      published_message = Hashie::Mash.new(data["message"])
      
      Emlogger.instance.log guid

      thread = MessageThread.first
      message = thread.messages.create(
        author_id: published_message.author_id,
        body: published_message.body,
        timestamp: published_message.timestamp
      )

      Emlogger.instance.log message.inspect
      Emlogger.instance.log message.attributes

      response = {message: message.attributes, guid: guid}

      Emlogger.instance.log response
    
       Emlogger.instance.log "about to publish"  
       MessageController.publish("/users", response)
    end
  end

end