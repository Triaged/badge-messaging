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
      thread = MessageThread.first
      
      published_message = Hashie.new(data["message"])

      message = thread.messages.create(
        author_id: published_message.author_id,
        body: published_message.body,
        timestamp: published_message.timestamp
      )

       MessageController.publish("/users/messages/#{message.author_id}", message.as_json)
    end
  end

end