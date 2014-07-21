class MessageController < FayeRails::Controller

	channel '/threads/messages/*' do
    monitor :subscribe do
      puts "Client #{client_id} subscribed to #{channel}."
    end
    monitor :unsubscribe do
      puts "Client #{client_id} unsubscribed from #{channel}."
    end
    monitor :publish do
      puts "Client #{client_id} published #{data.inspect} to #{channel}."
      #thread = MessageThread.first
      
      # published_message = Hashie.new(data["message"])

      # # message = thread.messages.create(
      # #   author_id: published_message.author_id,
      # #   body: published_message.body,
      # #   timestamp: published_message.timestamp
      # # )
    msg = {
          message: {id: "123", author_id: "1", body: "hello Jeffrey" }, 
          guid: "123"
    }
       puts "about to publish"  
       MessageController.publish("/users", msg)
    end
  end

end