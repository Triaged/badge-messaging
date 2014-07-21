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
      #thread = MessageThread.first
      
      published_message = Hashie.new(data["message"])
      guid = data["guid"]

      message = thread.messages.create(
        author_id: published_message.author_id,
        body: published_message.body,
        timestamp: published_message.timestamp
      )

      response = {message: message.attributes, guid: guid}
    
       Emlogger.instance.log "about to publish"  
       MessageController.publish("/users", response)
    end
  end

end